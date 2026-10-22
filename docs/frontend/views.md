# Views and Layouts

Lesli's frontend is Rails-first and server-rendered. Rails views provide the page structure, LesliView supplies reusable interface components, Tailwind CSS handles presentation, and Turbo and Alpine.js add interaction where it is useful.

An engine normally owns its domain-specific views while reusing the application shell and components supplied by the framework. This keeps each engine independent without making every engine rebuild navigation, page headers, forms, tables, and feedback states.

| Layer | Responsibility |
| --- | --- |
| Lesli | Application layouts, navigation, notifications, shared helpers, and frontend conventions |
| LesliView | Reusable ViewComponents, form builders, layouts, elements, and widgets |
| LesliAssets | Tailwind theme, fonts, icons, JavaScript dependencies, and compiled assets |
| Engine or host application | Domain views, engine navigation, feature-specific styles, and behavior |

---

## Choose the Right Layout

The controller hierarchy selects the appropriate layout automatically.

| Base controller | Layout | Use |
| --- | --- | --- |
| `Lesli::ApplicationLesliController` | `lesli/layouts/application-lesli` | Authenticated application and engine pages |
| `Lesli::ApplicationController` | `lesli/layouts/application-public` | Standalone public pages |
| `Lesli::ApplicationDeviseController` | `lesli/layouts/application-devise` | Authentication pages provided through LesliShield |

In most engines, inherit from `Lesli::ApplicationLesliController` and let Rails select the layout:

```ruby
module MyEngine
  class TicketsController < Lesli::ApplicationLesliController
    def index
      @application_html_title = "Tickets"
      @application_html_description = "Manage customer support tickets."
      @tickets = TicketService.new(current_user, query).index
    end
  end
end
```

Set `@application_html_title` and `@application_html_description` when a page needs explicit metadata. Otherwise, Lesli derives the title from the controller and action.

### Authenticated application shell

`application-lesli` composes the complete application shell in this order:

1. Document metadata, runtime data, Turbo settings, shared assets, and analytics
2. Application header and optional engine navigation
3. Flash notification target
4. Optional sidebar and the page content
5. A Turbo-permanent SVG icon library

The shared asset partial loads the global LesliAssets stylesheet, the LesliView stylesheet, the current engine's `application` stylesheet, and the shared JavaScript bundle.

### Public and authentication pages

`application-public` is intentionally minimal. It supplies the document head, page body, and analytics, but it does not load the authenticated application shell or its assets. A standalone public page can add page-specific styles or tags through `content_for :head`:

```erb
<% content_for :head do %>
  <%= stylesheet_link_tag "marketing", media: "all" %>
<% end %>
```

The Devise layout is also minimal, but it loads the shared public stylesheet and the stylesheet selected by the LesliShield controller.

---

## Build an Engine Page

Keep templates focused on composition. Put shared interface patterns in LesliView and domain-specific markup in the engine.

```erb
<%= render LesliView::Layout::Container.new("support-tickets") do %>
  <%= render LesliView::Components::Header.new(
    "Tickets",
    "Review and manage customer requests.",
    new_path: new_ticket_path,
    new_label: "Create ticket"
  ) %>

  <%= render LesliView::Elements::Table.new(
    columns: [
      { label: "ID", field: "uid" },
      { label: "Subject", field: "subject" },
      { label: "Status", field: "status" }
    ],
    records: @tickets.fetch(:records),
    link: ->(ticket) { ticket_path(ticket) }
  ) %>
<% end %>
```

Use standard Rails partials for markup that belongs to one feature. Promote a pattern to LesliView only when it has a stable public interface and is useful across multiple engines.

See the [LesliView documentation](/gems/view/) for the available layouts, components, elements, forms, charts, and widgets.

---

## Engine Navigation

An engine can provide navigation at:

```text
app/views/my_engine/partials/_navigation.html.erb
```

Use the Lesli navigation helper so links share the active, hover, focus, icon, and Turbo behavior of the application shell:

```erb
<%= navigation_item tickets_path, "Tickets", "ri-customer-service-2-line" %>
<%= navigation_item reports_path, "Reports", "ri-bar-chart-line" %>
```

The application shell renders the partial only when it exists. Keep this navigation limited to the current engine; the header already provides application-level actions.

An engine may also provide an optional sidebar at:

```text
app/views/my_engine/partials/_sidebar.html.erb
```

Prefer the horizontal engine navigation for a small set of destinations. Add a sidebar only when the feature hierarchy is too deep for that pattern.

---

## Useful View Helpers

| Helper | Purpose |
| --- | --- |
| `lesli_website_title` | Builds the document title or returns `@application_html_title` |
| `lesli_website_meta_description` | Returns `@application_html_description` |
| `lesli_application_body_class` | Identifies the instance, controller, and action on the `<body>` |
| `lesli_asset_path(engine, asset)` | Builds a logical asset name for the host application or an engine |
| `customization_instance_logo_tag` | Renders an application logo from LesliAssets |
| `navigation_item` | Renders a standard engine navigation list item |
| `navigation_link` | Renders only the standard navigation link |

`lesli_asset_path` returns a logical asset name such as `lesli_assets/application`; pass that result to Rails helpers such as `stylesheet_link_tag` or `javascript_include_tag`.

---

## Generate Resource Views

The view generator creates a starting point that uses LesliView conventions:

```shell
bin/rails generate lesli:views tickets subject:string description:text owner_id:integer
```

It creates:

```text
app/views/my_engine/tickets/
├── _form.html.erb
├── index.html.erb
├── new.html.erb
└── show.html.erb
```

The generated files are scaffolding, not a finished product. Replace generic select options, choose meaningful table columns, add empty and error states, and verify labels and actions before shipping the feature.

`lesli:scaffold` invokes this view generator together with the model, controller, service, migration, and route generators.

---

## View Conventions

* Use semantic HTML before adding utility classes or JavaScript behavior.
* Use LesliView for established framework patterns instead of reproducing their markup.
* Keep authorization and data shaping in controllers and services, not templates.
* Give icon-only controls an accessible label and mark decorative icons with `aria-hidden="true"`.
* Use Rails path helpers instead of hard-coded engine URLs.
* Keep view partials local to their feature until more than one engine needs them.
* Add page-specific behavior progressively; the rendered page should remain understandable without JavaScript.
