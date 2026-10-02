# Mailers

`Lesli::ApplicationLesliMailer` is the shared base for mailers that use Lesli's email templates and URL-building conventions.

```ruby
module MyEngine
  class NotificationMailer < Lesli::ApplicationLesliMailer
    default from: "notifications@example.com"
  end
end
```

The base mailer reads its default template path from `Lesli.config.mailer[:templates]`, which defaults to `lesli_assets/emails`.

---

## Configure URL Generation

`build_url` uses Action Mailer's `default_url_options`. Configure a host and protocol for each environment that sends email:

```ruby
# config/environments/production.rb
config.action_mailer.default_url_options = {
  host: "app.example.com",
  protocol: "https"
}
```

For local development with a nonstandard port:

```ruby
config.action_mailer.default_url_options = {
  host: "localhost",
  port: 3000,
  protocol: "http"
}
```

Build application URLs inside the mailer with an optional query hash:

```ruby
url = build_url("/password/edit", reset_password_token: token)
```

Always pass a path beginning with `/`.

---

## Send a Templated Email

Subclass methods call the protected `email` helper with template parameters, recipient, subject, and template name:

```ruby
module MyEngine
  class NotificationMailer < Lesli::ApplicationLesliMailer
    default from: "notifications@example.com"

    def assignment(user, ticket)
      email(
        {
          user: user,
          ticket: ticket,
          ticket_url: build_url("/support/tickets/#{ticket.id}")
        },
        to: user.email,
        subject: "Ticket assigned",
        template_name: "tickets/assignment"
      )
    end
  end
end
```

The helper exposes the parameter hash to the template as `@params`. It also builds `@app`, including the application URL and company information when `params[:user]` is a `Lesli::User`.

Deliver the message with standard Action Mailer APIs:

```ruby
MyEngine::NotificationMailer.assignment(user, ticket).deliver_later
```

---

## Template Location

With the default configuration, the example looks for a template below:

```text
app/views/lesli_assets/emails/tickets/assignment.html.erb
```

Override the shared template root in the Lesli initializer when the application provides a different template collection:

```ruby
Lesli.configure do |config|
  config.mailer = config.mailer.merge(
    templates: "my_engine/emails"
  )
end
```

The template would then live below `app/views/my_engine/emails/`.

---

## Recipient Helpers

The base mailer includes protected helpers that format arrays of users or contact hashes with display names:

```ruby
recipients = build_recipients_from_users(users)
contacts = build_recipients_from_contacts(
  [{ name: "Support", email: "support@example.com" }]
)
```

Both helpers expect arrays. They return `nil` for other input types.

---

## Development Delivery

Use the local email-preview setup from the [installation guide](/engines/lesli/start/installation/#local-email-preview) to inspect messages without sending them to a real provider.

For production, configure the host application's Action Mailer delivery method and provider credentials separately. `Lesli::ApplicationLesliMailer` does not configure SMTP or an external email service.
