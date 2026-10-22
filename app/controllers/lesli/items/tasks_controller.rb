=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    module Items
        class TasksController < ApplicationLesliController
            before_action :set_taskable, only: :create
            before_action :set_task, only: :update

            def create
                task = @taskable.add_task!(
                    creator: current_user,
                    title: task_params[:title]
                )
                refresh_tasks

                message = I18n.t("lesli.items.tasks.created")
                respond_with_lesli(
                    turbo: [
                        stream_notification_success(message),
                        tasks_stream
                    ],
                    json: {
                        message: message,
                        task: task_payload(task)
                    },
                    status: :created
                )
            rescue ActiveRecord::RecordInvalid => error
                respond_with_task_errors(error.record)
            end

            def update
                @task.update!(done: !@task.done?)

                message = task_status_message
                respond_with_lesli(
                    turbo: [
                        stream_notification_success(message),
                        turbo_stream.replace(
                            helpers.dom_id(@task, scope_key)
                        ) do
                            render_task(@task)
                        end
                    ],
                    json: {
                        message: message,
                        task: task_payload(@task)
                    }
                )
            rescue ActiveRecord::RecordInvalid => error
                respond_with_task_errors(error.record)
            end

            private

            def scope_key
                ActiveSupport::Inflector
                    .underscore(task_class.name)
                    .tr("/", "_")
            end

            def task_class
                self.class.module_parent.const_get("Task")
            end

            def taskable_class
                allowed_taskable_classes.find do |klass|
                    klass.name == params.require(:taskable_type)
                end || raise(
                    ActiveRecord::RecordNotFound,
                    "Unauthorized taskable type"
                )
            end

            def allowed_taskable_classes
                []
            end

            def set_task
                @task = task_class.find(params[:id])
                ensure_taskable_access!(@task.taskable)
            end

            def set_taskable
                @taskable = taskable_class.find(
                    params.require(:taskable_id)
                )
                ensure_taskable_access!(@taskable)
            end

            def ensure_taskable_access!(taskable)
                allowed = taskable.respond_to?(:lesli_item_accessible_by?) &&
                    taskable.lesli_item_accessible_by?(current_user)

                raise ActiveRecord::RecordNotFound unless allowed
            end

            def task_params
                params.require(scope_key.to_sym).permit(:title)
            end

            def render_task(task)
                LesliView::Items::Task
                    .new(task, scope_key)
                    .render_in(view_context)
            end

            def task_payload(task)
                {
                    id: task.id,
                    title: task.title,
                    done: task.done?,
                    taskable_type: task.taskable_type,
                    taskable_id: task.taskable_id,
                    creator: {
                        id: task.user_id,
                        name: task.user.name
                    },
                    created_at: task.created_at,
                    updated_at: task.updated_at
                }
            end

            def refresh_tasks
                association_name =
                    @taskable.class.lesli_tasks_association_name

                @taskable.public_send(association_name).reset
            end

            def task_status_message
                status = @task.done? ? :completed : :reopened
                I18n.t("lesli.items.tasks.#{status}")
            end

            def tasks_stream(task: nil)
                turbo_stream.replace(
                    helpers.dom_id(@taskable, :tasks)
                ) do
                    LesliView::Items::Tasks
                        .new(@taskable, task: task)
                        .render_in(view_context)
                end
            end

            def respond_with_task_errors(task)
                turbo = [
                    stream_notification_danger(
                        task.errors.full_messages.to_sentence
                    )
                ]

                if task.new_record?
                    refresh_tasks
                    turbo << tasks_stream(task: task)
                end

                respond_with_lesli(
                    turbo: turbo,
                    json: { errors: task.errors },
                    status: :unprocessable_content
                )
            end
        end
    end
end
