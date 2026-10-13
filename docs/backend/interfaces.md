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

`respond_with_action` returns the framework's legacy HTTP 490 action response. Use it only for clients that already implement that compatibility contract.

Use `respond_with_forbidden` for authorization failures. It returns HTTP 403 for HTML, JSON, and Turbo Stream requests. A missing or invalid authenticated session belongs to the authentication flow instead; navigational requests are redirected to login by LesliShield. The older `respond_with_unauthorized` name is retained as an alias so existing engines continue to work.

### Flash and Turbo helpers

The responder defines flash setters for `info`, `success`, `warning`, and `danger`. Each level also has a `stream_notification_<level>` variant that updates the shared notification target.

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
