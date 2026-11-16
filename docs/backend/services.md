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

The base class stores `current_user`, `query`, a result resource, and a list of errors for the lifetime of the service instance.

## CRUD and Selector Contract

One service represents one resource and follows the Rails resource lifecycle:

```ruby
TicketService#index
TicketService#list
TicketService#show
TicketService#create
TicketService#update
TicketService#destroy
```

Keep custom actions such as `close!`, `assign!`, imports, or notifications out
of the service. Implement them in the resource operator. A service may invoke
an operator when additional domain work is an inseparable part of a CRUD
operation.

### Complete CRUD Example

The base class intentionally does not provide empty CRUD methods. Implement
the operations supported by the resource in its concrete service:

```ruby
module MyEngine
    class TicketService < Lesli::ApplicationLesliService
        def find(id:)
            super(tickets.find_by(id: id))
        end

        def index
            tickets
                .order(id: :desc)
                .page(query.dig(:pagination, :page))
                .per(query.dig(:pagination, :perPage))
        end

        def show
            resource
        end

        def create(attributes)
            self.resource = tickets.new(attributes)

            unless resource.save
                error(resource.errors.full_messages.to_sentence)
            end

            self
        end

        def update(attributes)
            unless resource.update(attributes)
                error(resource.errors.full_messages.to_sentence)
            end

            self
        end

        def destroy
            unless resource.destroy
                error(resource.errors.full_messages.to_sentence)
            end

            self
        end

        private

        def tickets
            current_user.account.my_engine.tickets
        end
    end
end
```

The return values are part of the service contract:

| Method | Expected return value |
| ------ | --------------------- |
| `find` | The service object, with the record available through `result` |
| `index` | An Active Record relation or collection |
| `list` | A lightweight collection of selector options, usually `id` and `name` |
| `show` | The stored record or a detailed query result |
| `create` | The service object |
| `update` | The service object |
| `destroy` | The service object |

Assign the new record to `resource` before calling `save`. When validation
fails, the controller can retrieve the invalid record through `result` and
render the form without losing its values.

### Selector Lists

`list` belongs in the resource service. It is a read operation for selection
components, not a business workflow and not an operator responsibility.
Implement it whenever a resource needs selector options:

* `index`: administrative listing, normally paginated and containing table data.
* `list`: lightweight selector options, normally only `id` and `name`, without pagination.
* `show`: the detail of one resource.

Keep account scoping and access restrictions in `list`, and select only the
columns needed to build the options. Explicit filters are appropriate; an
`options: true` switch on `index` is unnecessary.

```ruby
def list
    current_user.account.my_engine.tickets.order(:subject, :id)
        .select(:id, "subject AS name")
end
```

Do not add business workflows such as `validate`, `import`, or `notify` to the
service. Those belong in an operator.

`find` is the existing lookup helper used before `show`, `update`, and
`destroy`, not an additional business action. The same exception applies to
inherited result, error, and cache helpers. Private methods may organize CRUD
implementation without expanding the service's public business API.

Rails `new` and `edit` prepare forms; they do not require matching service
methods or empty placeholders.

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

Mutation methods should return `self` (or `response(resource)`) so callers can inspect `successful?`, `result`, and `errors`:

```ruby
def create(attributes)
    self.resource = current_user.account.my_engine.tickets.new(attributes)

    unless resource.save
        error(resource.errors.full_messages.to_sentence)
    end

    self
end
```

The base class provides:

| Method | Purpose |
| ------ | ------- |
| `successful?` | Returns `true` when no errors have been registered |
| `error(message)` | Appends an error message |
| `errors` | Returns all registered errors |
| `errors_as_sentence` | Joins errors into one sentence |
| `result` | Returns the stored resource |
| `response(resource)` | Protected helper that stores a result and returns `self` |
| `found?` | Reports whether a stored resource is present |

The base class does not implement CRUD methods. Each resource service exposes
only the operations it supports and uses `destroy` to match Rails controllers
and Active Record. Calling an operation that was not implemented raises Ruby's
normal `NoMethodError` instead of silently returning `nil`.

A service object is truthy even when it contains errors. Always inspect
`successful?` after a mutation; do not use `if service.update(attributes)`.
Keep the invalid record and its model errors available through `result`.

Use one service instance for one controller operation. Query methods return
their data directly; mutation methods return `self` so controllers can inspect
the standard result and error contract.

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
rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => exception
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
            json: ticket.result,
            redirect: ticket_path(ticket.result)
        )
    else
        @ticket = ticket.result

        respond_with_lesli(
            turbo: stream_notification_danger(ticket.errors_as_sentence),
            json: { errors: ticket.errors },
            html: "my_engine/tickets/new",
            status: :unprocessable_entity
        )
    end
end
```

Keep HTTP rendering in controllers, CRUD failures in services, and non-CRUD
business behavior in operators. See the
[application architecture](/engines/lesli/backend/architecture/) for the full
dependency contract.

## Core Read APIs

Core exposes separate administrative and selector reads:

```ruby
users = Lesli::UserService.new(current_user, query).index
options = Lesli::UserService.new(current_user).list
reviewers = Lesli::UserService.new(current_user).list(role: "reviewer")
roles = Lesli::RoleService.new(current_user).list
```

The user `index` returns a paginated relation. User `list` returns an unpaginated
array with `id` and `name` string keys, using the email as the display name when
no first name is available. Its optional comma-separated role filter uses
Shield associations and returns no matches when Shield is absent.

Role `list` returns a relation selecting only `id` and `name`. It requires
Shield's permission context and restricts results to the current account and
permission level.

The redundant `UserService#sessions`, `#roles`, and `#logs` methods were removed;
read those associations from the scoped record returned by `show`.
Optional-engine associations require their owning engine to be installed.
