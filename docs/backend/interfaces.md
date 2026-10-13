# Controller Interfaces

`Lesli::ApplicationLesliController` composes small interfaces that keep common request and response behavior consistent across engines.

| Interface | Responsibility |
| --------- | -------------- |
| `Lesli::RequesterInterface` | Locale selection and normalized query parameters |
| `Lesli::ResponderInterface` | Pagination, HTML, JSON, Turbo Stream, errors, and notifications |
| `Lesli::CustomizationInterface` | Hook for account-specific interface customization |
| `LesliShield::AuthenticationInterface` | Authentication when LesliShield is installed |
| `LesliShield::AuthorizationInterface` | Authorization when LesliShield is installed |
| `LesliAudit::LoggerInterface` | Request logging when LesliAudit is installed |

Applications normally receive these interfaces by inheriting from `Lesli::ApplicationLesliController`; they do not need to include them individually.

---

## Requester Interface

`set_locale` chooses a locale in this order:

1. The locale stored in `session[:locale]`
2. The configured `I18n.default_locale`
3. A nonblank `Require-Language` request header, which takes precedence

Unsupported locales fall back to `I18n.default_locale`.

`set_requester` builds the `query` hash used by services. The recognized parameters are `search`, `perPage`, `page`, `orderBy`, and `order`.

The interface converts pagination values to integers but does not enforce minimums, maximums, sortable fields, or order directions. Validate those constraints in the service before applying them to a query.

---

## Responder Interface

### Standard response helpers

| Helper | Result |
| ------ | ------ |
| `respond_with_lesli` | Selects an HTML, JSON, or Turbo Stream response |
| `respond_with_pagination` | Wraps a Kaminari collection with pagination metadata |
| `respond_with_not_found` | Renders the shared 404 response |
| `respond_with_forbidden` | Renders the shared HTTP 403 response when an authenticated user lacks privileges |
| `respond_with_unauthorized` | Backwards-compatible alias for `respond_with_forbidden` |
| `respond_with_json` | Renders a JSON payload with HTTP 200 |
| `respond_with_json_not_found` | Renders the standard JSON 404 body |
| `respond_with_json_unauthorized` | Renders the standard JSON 403 body |
| `respond_with_http` | Renders a JSON payload with an explicit status |

`respond_with_http` passes non-null payloads directly to Rails for JSON serialization. When the payload is `nil`, it returns a headers-only response with the requested status.

### Action-required responses

`respond_with_action` implements the Lesli action-required protocol for JSON clients. It returns the Lesli-specific HTTP status `490` and a body containing the action the client must execute:

```ruby
respond_with_action(
  "redirect_to_login",
  "Authentication required"
)
```

```json
{
  "message": "Authentication required",
  "action": "redirect_to_login"
}
```

Clients that consume this response must detect status `490` and dispatch the value of `action`. A centralized HTTP interceptor is recommended so every endpoint follows the same behavior.

Use this response when the original request cannot continue until the client performs an action. When the request completed successfully and the action is only a suggested next step, return a normal success status and include the action in the JSON payload instead.

Status `490` is part of the Lesli API contract, not a standard HTTP status. Do not use it in place of standard authentication, authorization, missing-resource, or validation responses such as `401`, `403`, `404`, or `422`.

`respond_with_lesli` accepts `html:`, `json:`, `turbo:`, `redirect:`, `status:`, and `redirect_status:`. Use `html:` to render a template and `redirect:` to redirect an HTML request; providing both raises `ArgumentError`. If neither is provided, Rails renders the current action template. `status:` defaults to `:ok`, while `redirect_status:` defaults to `:see_other`.

### Response examples

Render an explicit HTML template, return a JSON payload, or execute multiple Turbo Stream actions from the same controller action:

```ruby
respond_with_lesli(
  turbo: [
    stream_notification_success("Ticket created successfully"),
    turbo_stream.prepend(
      "tickets",
      partial: "lesli_support/tickets/ticket",
      locals: { ticket: ticket }
    )
  ],
  json: {
    message: "Ticket created successfully",
    ticket: ticket
  },
  html: "lesli_support/tickets/show",
  status: :created
)
```

When the HTML response should use the current action template, omit `html:`. This is useful for index actions that also expose JSON:

```ruby
def index
  @tickets = respond_with_pagination(
    TicketService.new(current_user, query).index
  )

  respond_with_lesli(json: @tickets)
end
```

Use `redirect:` for a successful HTML form submission. The HTML response redirects with HTTP 303 by default, while `status:` applies to JSON and Turbo Stream rendering:

```ruby
success("Ticket created successfully")

respond_with_lesli(
  redirect: ticket_path(ticket),
  json: {
    message: "Ticket created successfully",
    ticket: ticket
  },
  turbo: stream_redirection(ticket_path(ticket)),
  status: :created
)
```

Render validation errors with HTTP 422 in every rendered format:

```ruby
respond_with_lesli(
  html: "lesli_support/tickets/new",
  json: {
    message: "Ticket could not be created",
    errors: ticket.errors
  },
  turbo: stream_notification_danger(
    ticket.errors.full_messages.to_sentence
  ),
  status: :unprocessable_entity
)
```

An action can support only JSON and Turbo Stream while leaving ordinary HTML rendering to Rails:

```ruby
respond_with_lesli(
  json: { message: "Translation deployed successfully" },
  turbo: stream_notification_success(
    "Translation deployed successfully"
  )
)
```

Override the default redirect status only when the HTTP workflow requires it:

```ruby
respond_with_lesli(
  redirect: ticket_path(ticket),
  redirect_status: :temporary_redirect
)
```

Use `respond_with_forbidden` for authorization failures. It returns HTTP 403 for HTML, JSON, and Turbo Stream requests. A missing or invalid authenticated session belongs to the authentication flow instead; navigational requests are redirected to login by LesliShield. The older `respond_with_unauthorized` name is retained as an alias so existing engines continue to work.

### Flash and Turbo helpers

The responder defines flash setters for `info`, `success`, `warning`, and `danger`. Each level also has a `stream_notification_<level>` variant that replaces the shared notification target.

```ruby
success("Ticket saved")

respond_with_lesli(
  turbo: stream_notification_success("Ticket saved"),
  json: { status: "ok" }
)
```

`stream_redirection(path)` renders the shared redirection partial into the notification target. Use it inside a Turbo Stream response:

```ruby
respond_with_lesli(
  turbo: stream_redirection(ticket_path(ticket))
)
```

---

## Optional Interfaces

LesliShield and LesliAudit interfaces are included only when their constants are available at application boot. Add those gems before booting the application; loading them later does not retroactively add callbacks to an already defined controller class.

The customization interface currently provides the `set_customizer` lifecycle hook. Treat it as an extension point; the core implementation does not populate account branding by itself.
