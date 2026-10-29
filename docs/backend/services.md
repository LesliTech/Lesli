# Services

Lesli service objects implement account-scoped CRUD outside controllers.
Framework services inherit from `Lesli::ApplicationLesliService`. Business
actions that are not CRUD belong in [Operators](/engines/lesli/backend/operators/).

```ruby
module MyEngine
  class TicketService < Lesli::ApplicationLesliService
  end
end
```

Initialize a service with the current user and the normalized controller query:

```ruby
service = MyEngine::TicketService.new(current_user, query)
```

The base class stores `current_user`, `query`, a result resource, and a list of failures for the lifetime of the service instance.

## CRUD Contract

One service represents one resource and follows the Rails resource lifecycle:

```ruby
TicketService#index
TicketService#show
TicketService#create
TicketService#update
TicketService#destroy
```

Keep custom actions such as `close!`, `assign!`, imports, or notifications out
of the service. Implement them in the resource operator. A service may invoke
an operator when additional domain work is an inseparable part of a CRUD
operation.

---

## Account-scoped Queries

Build queries through the current user's account association. This preserves the tenant boundary in the service layer:

```ruby
def index
  current_user.account.my_engine.tickets
    .order(id: :desc)
    .page(query.dig(:pagination, :page))
    .per(query.dig(:pagination, :perPage))
end
```

Do not query an engine model globally when the resource belongs to an account. Controllers and route authorization do not replace account scoping in database queries.

Request ordering values must be allowlisted before they reach `order`:

```ruby
def index
  allowed_columns = %w[id subject created_at]
  allowed_directions = %w[asc desc]

  column = query.dig(:order, :by).to_s
  direction = query.dig(:order, :dir).to_s.downcase

  column = "id" unless allowed_columns.include?(column)
  direction = "desc" unless allowed_directions.include?(direction)

  current_user.account.my_engine.tickets.order(column => direction)
end
```

---

## Find and Result Contract

The base `find` method accepts a resource, stores it, and returns the service object:

```ruby
def find(id:)
  ticket = current_user.account.my_engine.tickets.find_by(id: id)
  super(ticket)
end
```

The controller can then use the service contract:

```ruby
ticket = TicketService.new(current_user, query).find(id: params[:id])
return respond_with_not_found unless ticket.found?

@ticket = ticket.result
```

`found?` checks whether the stored resource is present, and `result` returns that resource.

---

## Mutations and Failures

Mutation methods should return `self` so callers can inspect `successful?`, `result`, and `errors`:

```ruby
def create(attributes)
  ticket = current_user.account.my_engine.tickets.new(attributes)

  if ticket.save
    self.resource = ticket
  else
    error(ticket.errors.full_messages.to_sentence)
  end

  self
end
```

The base class provides:

| Method | Purpose |
| ------ | ------- |
| `successful?` | Returns `true` when no failures have been registered |
| `error(message)` | Appends a failure message |
| `errors` | Returns all registered failures |
| `errors_as_sentence` | Joins failures into one sentence |
| `result` | Returns the stored resource |
| `found?` | Reports whether a stored resource is present |

The base implementations of `list`, `index`, `show`, `update`, and `delete`
are extension points and do not perform database operations. New resource
services should expose `destroy` to match Rails controllers and Active Record;
implement only the methods the resource needs.

---

## Operator Coordination

Services may use an operator while coordinating a CRUD transaction:

```ruby
def destroy
  Ticket.transaction do
    TicketOperator.new(
      ticket: resource,
      actor: current_user
    ).cancel_pending_tasks!

    resource.destroy!
  end

  self
rescue ActiveRecord::RecordInvalid => exception
  error(exception.record.errors.full_messages.to_sentence)
  self
end
```

The service owns this transaction because it coordinates the complete destroy
operation. Operators must not call back into the resource service.

---

## Cache Keys

Services can build account- or user-scoped cache keys:

```ruby
cache_key_for_account(:index)
cache_key_for_user(:profile)
```

The generated key contains the scope, account or user ID, service class, optional method name, and `query[:cacheKey]` when provided.

These helpers require a current user with the corresponding account context. Treat a client-provided `cacheKey` as a cache variant, not as authorization or tenant identity.

---

## Controller Integration

A typical controller keeps orchestration at the boundary and delegates persistence to the service:

```ruby
def create
  ticket = TicketService.new(current_user, query).create(ticket_params)

  if ticket.successful?
    respond_with_lesli(
      turbo: stream_redirection(ticket_path(ticket.result)),
      json: ticket.result
    )
  else
    respond_with_lesli(
      turbo: stream_notification_danger(ticket.errors_as_sentence),
      json: { errors: ticket.errors }
    )
  end
end
```

Keep HTTP rendering in controllers, CRUD failures in services, and non-CRUD
business behavior in operators. See the
[application architecture](/engines/lesli/backend/architecture/) for the full
dependency contract.
