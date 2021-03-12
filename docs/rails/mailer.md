# Rails mailer

## New mailer

- Every mailer should inherit from ApplicationLesliMailer
- Every mailer should represent a specific controller
- Every mailer should belong to one controller only

**Example:**

```ruby
class UserMailer < ApplicationLesliMailer
end
```

## Simple email

```ruby
def welcome_simple
    user = params[:user]
    mail(to: email_address_with_name(user.email, user.full_name), subject: "welcome email")
end
```

## Email with multiple recipients

```ruby
def welcome_multiple
    recipients = build_recipients_from_params(params)
    mail(
        subject: "welcome email",
        bcc: recipients[:bcc], 
        cc: recipients[:cc], 
        to: recipients[:to]
    )
end
```
