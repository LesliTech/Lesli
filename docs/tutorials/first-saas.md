# Build Your First SaaS with Lesli

Build a small project management application with Rails 8 and Lesli. By the end, you will be able to create, list, view, update, and delete projects; add tasks to each project; and mark those tasks as complete.

This tutorial keeps the feature inside the host Rails application. You will use standard Rails generators for application-owned resources, then add Lesli's shared application shell, service result contract, database workflow, and LesliView components.

## 1. Introduction

The finished application has two resources:

* A `Project` with a name, description, and many tasks.
* A `Task` that belongs to a project and can be marked complete.

The implementation deliberately excludes authentication, account scoping, background jobs, and custom Engines. Those concerns can be added after the basic workflow is clear.

| Concern | Implementation used here |
| --- | --- |
| Models, migrations, associations, routes, and tests | Standard Rails |
| Database preparation | Lesli `lesli:db:prepare` task |
| Application layout and request conventions | `Lesli::ApplicationLesliController` |
| Business-operation result contract | `Lesli::ApplicationLesliService` |
| Page layout, headers, tables, buttons, and forms | LesliView |

## 2. Prerequisites

Complete [Getting Started](/engines/lesli/start/) before continuing. You should have a Rails 8.1 application with Lesli Core installed, the Lesli generator completed, and the database prepared.

No additional gems or JavaScript packages are required.

Use the default Rails application stack with Action Text enabled. LesliView currently loads Lexxy's Action Text integration, so a host application created with `--skip-action-text` cannot boot that integration.

> **Why this tutorial uses Rails generators**
> The current `lesli:model`, `lesli:controller`, `lesli:service`, `lesli:views`, and `lesli:scaffold` generators derive their namespace and destination from `ENGINE_ROOT`. They are intended for Lesli Engine repositories. Because this tutorial builds inside the host application, it uses supported Rails generators and adds Lesli conventions explicitly.

## 3. Create the Project Resource

Generate the two models and their controllers from the application root:

```shell
bin/rails generate model Project name:string description:text
bin/rails generate model Task project:references title:string completed:boolean
bin/rails generate controller Projects --skip-routes
bin/rails generate controller Tasks --skip-routes
```

These are standard Rails generators. They create application-owned models, migrations, tests, fixtures, controllers, and view directories without introducing an Engine namespace.

Before preparing the database, update the generated project migration so its table definition is:

```ruby
create_table :projects do |t|
  t.string :name, null: false
  t.text :description

  t.timestamps
end
```

Update the generated task migration in the same way:

```ruby
create_table :tasks do |t|
  t.references :project, null: false, foreign_key: true
  t.string :title, null: false
  t.boolean :completed, null: false, default: false

  t.timestamps
end
```

Define the associations and validations in `app/models/project.rb`:

```ruby
class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
end
```

Then update `app/models/task.rb`:

```ruby
class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true
end
```

Prepare the schema through Lesli:

```shell
bin/rails lesli:db:prepare
```

This invokes Rails `db:prepare`, rebuilds Lesli's resource index, initializes installed Engines for existing accounts, runs supported Engine setup tasks, and prints the framework status. It does not load seed data.

## 4. Implement Business Logic

### Use the Lesli application controller

Change the superclass in `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < Lesli::ApplicationLesliController
end
```

Your application controllers now use the Lesli application layout and its shared request, response, customization, and optional Engine integrations. Authentication and authorization callbacks are activated only when LesliShield is installed.

If your existing `ApplicationController` contains application-specific callbacks, keep them inside this class when changing the superclass.

### Add a project service

Create `app/services/project_service.rb`:

```ruby
class ProjectService < Lesli::ApplicationLesliService
  def index
    Project.includes(:tasks).order(created_at: :desc)
  end

  def find(id:)
    super(Project.includes(:tasks).find_by(id: id))
  end

  def create(attributes)
    self.resource = Project.new(attributes)
    error(resource.errors.full_messages.to_sentence) unless resource.save
    self
  end

  def update(attributes)
    error(resource.errors.full_messages.to_sentence) unless resource.update(attributes)
    self
  end

  def destroy
    error(resource.errors.full_messages.to_sentence) unless resource.destroy
    self
  end
end
```

`Lesli::ApplicationLesliService` stores a result and collected failures. Returning `self` lets the controller use `successful?`, `result`, and `errors_as_sentence` without inventing a different response shape for every operation.

This first application has no users or accounts, so its queries are intentionally global. In an authenticated SaaS application, scope queries through the current user's account as described in [Services](/engines/lesli/backend/services/).

Create `app/services/task_service.rb`:

```ruby
class TaskService < Lesli::ApplicationLesliService
  def initialize(project)
    super()
    @project = project
  end

  def create(attributes)
    self.resource = @project.tasks.new(attributes)
    error(resource.errors.full_messages.to_sentence) unless resource.save
    self
  end

  def complete(id:)
    self.resource = @project.tasks.find_by(id: id)

    unless resource
      error("Task not found")
      return self
    end

    error(resource.errors.full_messages.to_sentence) unless resource.update(completed: true)
    self
  end
end
```

### Add routes

Add the application resources inside `Rails.application.routes.draw` in `config/routes.rb`. Keep the `Lesli::Router.mount(self)` line created during installation:

```ruby
Rails.application.routes.draw do
  Lesli::Router.mount(self)

  resources :projects do
    resources :tasks, only: [:create, :update]
  end
end
```

The Lesli router continues to mount Core and any installed Engines. The resource routes remain ordinary host-application routes.

### Implement the controllers

Replace `app/controllers/projects_controller.rb` with:

```ruby
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = ProjectService.new.index
  end

  def show
    @task = Task.new
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    service = ProjectService.new.create(project_params)
    @project = service.result

    if service.successful?
      redirect_to project_path(@project), notice: "Project created successfully."
    else
      flash.now[:alert] = service.errors_as_sentence
      render :new, status: :unprocessable_content
    end
  end

  def update
    service = ProjectService.new.find(id: @project.id).update(project_params)
    @project = service.result

    if service.successful?
      redirect_to project_path(@project), notice: "Project updated successfully."
    else
      flash.now[:alert] = service.errors_as_sentence
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    service = ProjectService.new.find(id: @project.id).destroy

    if service.successful?
      redirect_to projects_path, notice: "Project deleted successfully."
    else
      redirect_to project_path(@project), alert: service.errors_as_sentence
    end
  end

  private

  def set_project
    service = ProjectService.new.find(id: params[:id])
    return redirect_to(projects_path, alert: "Project not found.") unless service.found?

    @project = service.result
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
```

Replace `app/controllers/tasks_controller.rb` with:

```ruby
class TasksController < ApplicationController
  before_action :set_project

  def create
    service = TaskService.new(@project).create(task_params)

    if service.successful?
      redirect_to project_path(@project), notice: "Task created successfully."
    else
      redirect_to project_path(@project), alert: service.errors_as_sentence
    end
  end

  def update
    service = TaskService.new(@project).complete(id: params[:id])

    if service.successful?
      redirect_to project_path(@project), notice: "Task completed."
    else
      redirect_to project_path(@project), alert: service.errors_as_sentence
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
```

The controllers use standard Rails strong parameters and redirects. Persistence and failure collection live in the service objects.

## 5. Build the User Interface

Lesli Core already depends on LesliView and LesliAssets. The shared application layout expects a host stylesheet at `app/assets/stylesheets/application.css`. Create it with the styles used by this tutorial:

```css
/* Host application styles loaded by the Lesli application layout. */

.project-section {
  margin-block: 2rem;
  padding: 1.5rem;
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  background: #ffffff;
}

.project-section h2 {
  margin-bottom: 1rem;
  color: #334155;
  font-size: 1.25rem;
  font-weight: 600;
}

.project-task-list {
  display: grid;
  gap: 0.75rem;
  margin-top: 1rem;
}

.project-task {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.75rem;
}

.project-task.is-complete span {
  color: #64748b;
  text-decoration: line-through;
}
```

### Project list

Create `app/views/projects/index.html.erb`:

```erb
<%= render LesliView::Layout::Container.new("projects") do %>
  <%= render LesliView::Components::Header.new(
    "Projects",
    "Create projects and track the work required to complete them.",
    new_path: new_project_path,
    new_label: "Create project"
  ) %>

  <%= render LesliView::Elements::Table.new(
    columns: [
      { label: "Name", field: "name" },
      { label: "Description", field: "description" }
    ],
    records: @projects,
    link: ->(project) { project_path(project) },
    empty: "No projects yet. Create your first project."
  ) %>
<% end %>
```

### Shared project form

Create `app/views/projects/_form.html.erb`:

```erb
<%= form_with(
  model: project,
  builder: LesliView::Forms::Builder,
  data: { turbo_frame: "_top" }
) do |form| %>
  <%= form.fieldset do %>
    <%= form.field_control_text :name %>
    <%= form.field_control_text :description %>
    <%= form.field_control_submit %>
  <% end %>
<% end %>
```

Create `app/views/projects/new.html.erb`:

```erb
<%= render LesliView::Layout::Container.new("new-project") do %>
  <%= render LesliView::Components::Header.new(
    "New project",
    "Define the outcome this project should deliver.",
    back: projects_path
  ) %>

  <%= render "form", project: @project %>
<% end %>
```

Create `app/views/projects/edit.html.erb`:

```erb
<%= render LesliView::Layout::Container.new("edit-project") do %>
  <%= render LesliView::Components::Header.new(
    "Edit project",
    @project.name,
    back: project_path(@project)
  ) %>

  <%= render "form", project: @project %>
<% end %>
```

These templates use the LesliView container, header, table, and form builder. Routing, form submission, and model binding remain standard Rails.

## 6. Add Tasks

Create `app/views/projects/show.html.erb`:

```erb
<%= render LesliView::Layout::Container.new("project-#{@project.id}") do %>
  <%= render LesliView::Components::Header.new(
    @project.name,
    @project.description,
    back: projects_path
  ) do %>
    <%= render LesliView::Elements::Button.new(
      "Edit",
      url: edit_project_path(@project),
      icon: "edit",
      info: false
    ) %>

    <%= render LesliView::Elements::Button.new(
      "Delete",
      url: project_path(@project),
      method: :delete,
      icon: "delete",
      danger: true,
      info: false,
      data: { turbo_confirm: "Delete this project and its tasks?" }
    ) %>
  <% end %>

  <section class="project-section">
    <h2>Add a task</h2>

    <%= form_with(
      model: [@project, @task],
      builder: LesliView::Forms::Builder,
      data: { turbo_frame: "_top" }
    ) do |form| %>
      <%= form.fieldset do %>
        <%= form.field_control_text :title %>
        <%= form.field_control_submit "Add task" %>
      <% end %>
    <% end %>
  </section>

  <section class="project-section">
    <h2>Tasks</h2>

    <% if @project.tasks.any? %>
      <ul class="project-task-list">
        <% @project.tasks.order(:created_at).each do |task| %>
          <li class="project-task <%= "is-complete" if task.completed? %>">
            <span><%= task.title %></span>

            <% unless task.completed? %>
              <%= render LesliView::Elements::Button.new(
                "Mark complete",
                url: project_task_path(@project, task),
                method: :patch,
                icon: "check",
                success: true,
                info: false,
                small: true
              ) %>
            <% end %>
          </li>
        <% end %>
      </ul>
    <% else %>
      <p>No tasks yet.</p>
    <% end %>
  </section>
<% end %>
```

The nested form associates each task with the current project. The update action exposes one intentional transition: incomplete to complete.

## 7. Run and Verify

Inspect the routes before starting the server:

```shell
bin/rails routes -g project
bin/rails routes -g task
```

Run the application:

```shell
bin/rails server
```

Open [http://127.0.0.1:3000/projects](http://127.0.0.1:3000/projects) and verify this workflow:

1. Create a project.
2. Return to the list and confirm it appears.
3. Open the project and add two tasks.
4. Mark one task complete.
5. Edit the project's name or description.
6. Delete the project and confirm its tasks are removed with it.

### Add a small model test

Rails created test files with the models. Replace `test/models/project_test.rb` with:

```ruby
require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "requires a name" do
    project = Project.new

    assert_not project.valid?
    assert_includes project.errors[:name], "can't be blank"
  end

  test "deletes its tasks" do
    project = Project.create!(name: "Website launch")
    project.tasks.create!(title: "Publish release notes")

    assert_difference("Task.count", -1) { project.destroy! }
  end
end
```

Run the host application's standard Rails test suite:

```shell
bin/rails test
```

### Troubleshooting

* **The Lesli layout reports a missing `application` asset:** confirm that `app/assets/stylesheets/application.css` exists.
* **A Lesli resource generator references `ENGINE_ROOT`:** use the Rails model and controller commands shown above. The Lesli resource generators currently target Engine repositories.
* **A route is missing or shadowed:** run `bin/rails routes` and confirm both `Lesli::Router.mount(self)` and the `resources :projects` block are present.
* **A migration was edited after it already ran:** create a corrective Rails migration, or roll back that migration in development before running `bin/rails lesli:db:prepare` again.

## 8. What's Next?

You now have a host-application feature that combines ordinary Rails resources with Lesli's shared runtime and UI conventions.

Continue with:

* [Architecture](/engines/lesli/about/architecture/) for the relationship between the host application, Core, Engines, and Gems.
* [Engines](/engines/) to add optional product capabilities.
* [Gems](/gems/) for reusable libraries and development tools.
* [LesliShield](/engines/shield/) when the application needs authentication, roles, and privileges.
* [LesliView](/gems/view/) for supported layouts, components, elements, and form APIs.
* [Development](/engines/lesli/start/development/) for working with Lesli from source.
* [LesliTesting](/gems/testing/) for shared testing tools used by Lesli packages.

When this domain needs independent ownership, releases, routes, and migrations, the natural next step is a custom Rails Engine. Follow the [Engine development conventions](/engines/lesli/contributing/engines/) for that advanced workflow.
