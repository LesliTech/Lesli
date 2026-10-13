# Controllers

Authenticated Lesli engine controllers inherit shared request, response, customization, security, and audit behavior from `Lesli::ApplicationLesliController`.

Define one application controller inside the engine namespace, then inherit resource controllers from it:

```ruby
module MyEngine
  class ApplicationController < Lesli::ApplicationLesliController
  end

  class TicketsController < ApplicationController
  end
end
```

Use `Lesli::ApplicationController` instead for public pages that do not need the authenticated engine lifecycle.

---

## Controller Lifecycle

`Lesli::ApplicationLesliController` runs the following callbacks:

1. Select the locale from the session or `Require-Language` request header.
2. Authenticate and authorize the request when LesliShield is installed.
3. Prepare customization state.
4. Normalize common query parameters into `query`.
5. Log the completed request when LesliAudit is installed.

It also uses the `lesli/layouts/application-lesli` layout and includes the requester and responder interfaces described in [Controller Interfaces](/engines/lesli/backend/interfaces/).

Security and audit callbacks are conditional. Inheriting from this controller does not install LesliShield or LesliAudit.

---

## Query Parameters

The requester interface exposes normalized request options through the `query` reader:

```ruby
{
  search: params[:search],
  pagination: {
    perPage: params[:perPage]&.to_i || 12,
    page: params[:page]&.to_i || 1
  },
  order: {
    by: params[:orderBy] || "id",
    dir: params[:order] || "desc"
  }
}
```

Pass this hash into service objects instead of repeating pagination and ordering parsing in every controller:

```ruby
def index
  scope = TicketService.new(current_user, query).index
  @tickets = respond_with_pagination(scope)
end
```

The service remains responsible for allowlisting sortable columns and safe order directions before using request-derived values in a database query.

---

## Multi-format Responses

Use `respond_with_lesli` when an action supports HTML, JSON, or Turbo Stream requests:

```ruby
def update
  ticket = TicketService.new(current_user, query).find(id: params[:id])
  return respond_with_not_found unless ticket.found?

  if ticket.update(ticket_params)
    respond_with_lesli(
      turbo: stream_notification_success("Ticket updated"),
      json: ticket.result,
      redirect: ticket_path(ticket.result)
    )
  else
    respond_with_lesli(
      turbo: stream_notification_danger(ticket.errors_as_sentence),
      json: { errors: ticket.errors },
      html: "my_engine/tickets/edit",
      status: :unprocessable_entity
    )
  end
end
```

`html:` identifies a template or renderable, while `redirect:` identifies an HTML redirect destination. Do not pass the result of `redirect_to` through `html:` and do not provide both options in one call. When neither is present, Rails renders the current action's HTML template.

`status:` applies to HTML, JSON, and Turbo Stream renders and defaults to `:ok`. HTML redirects use `redirect_status: :see_other` by default. Only provide formats the action is expected to serve; the responder selects the payload matching the request format.

See [Controller Interfaces](/engines/lesli/backend/interfaces/) for complete examples covering multiple Turbo Stream actions, redirects, JSON payloads, default HTML rendering, and validation errors.

---

## Pagination Responses

`respond_with_pagination` expects a paginated collection that responds to Kaminari's pagination methods:

```ruby
records = Ticket
  .order(id: :desc)
  .page(query[:pagination][:page])
  .per(query[:pagination][:perPage])

payload = respond_with_pagination(records)
```

The returned hash has this shape:

```ruby
{
  pagination: {
    page: 1,
    pages: 4,
    total: 42,
    results: 12
  },
  records: records
}
```

Passing an ordinary, unpaginated Active Record relation raises an error because the required pagination methods are absent.

---

## Errors and Notifications

The shared controller provides:

* `respond_with_not_found(message = nil)` for HTML, JSON, and Turbo Stream 404 responses
* `respond_with_forbidden(details = {})` for authorization failures after a user has authenticated
* `info`, `success`, `warning`, and `danger` for flash messages
* `stream_notification_info`, `stream_notification_success`, `stream_notification_warning`, and `stream_notification_danger` for Turbo Stream notifications
* `stream_redirection(path)` for redirects initiated from a Turbo Stream response

Authorization failures return HTTP 403. `respond_with_unauthorized` remains available as a backwards-compatible alias, but new code should use `respond_with_forbidden`. Authentication failures are separate: an unauthenticated browser request is handled by LesliShield's authentication interface and redirected to login.

Avoid returning authorization details in production. The built-in forbidden responder suppresses its diagnostic details when Rails runs in production.

---

## Strong Parameters

Use standard Rails strong parameters at the controller boundary:

```ruby
private

def ticket_params
  params.require(:ticket).permit(:subject, :description, :priority_id)
end
```

Keep required parameter names aligned with the form and API payload.
