# Operators

Operators implement named operations that are not part of a resource's CRUD
lifecycle. They are useful for state transitions, data processing, imports,
notifications, and workflows involving more than one model. Selector queries
belong in the service's `list` method; they do not require an operator.

```ruby
module MyEngine
    class TicketOperator
        def initialize(ticket:, actor:)
            @ticket = ticket
            @actor = actor
        end

        def close!
            Ticket.transaction do
                ticket.update!(status: :closed)

                ticket.record_activity!(
                    actor: actor,
                    code: :ticket_closed
                )
            end

            ticket
        end

        def reopen!
            Ticket.transaction do
                ticket.update!(status: :open)

                ticket.record_activity!(
                    actor: actor,
                    code: :ticket_reopened
                )
            end

            ticket
        end

        private

        attr_reader :actor, :ticket
    end
end
```

Operators live under `app/operators`:

```text
app/operators/my_engine/ticket_operator.rb
```

## Public Method Names

Use explicit operation names instead of a generic `call` or `operate` method
when one operator provides several actions:

```ruby
operator.close!
operator.reopen!
operator.assign!(owner: user)
operator.notify_owner!
```

Use `!` for operations that raise when they cannot complete, following the
convention used by Active Record persistence methods.
Predicates should describe the decision they answer:

```ruby
operator.closable?
operator.assignable_to?(user)
```

`validate` is appropriate when the class and input make the operation clear,
for example `UserOperator#validate` for a dataset of users. Use a more specific
name such as `validate_closure!` when the operator has several validation
workflows. Multiple explicit methods can share one operator; a generic `call`
or `operate` entry point is not required.

## Construction

Pass the already scoped resource and the dependencies required by the
operation:

```ruby
TicketOperator.new(
    ticket: ticket,
    actor: current_user
)
```

When a controller needs a resource, resolve it through the account-scoped
resource service. Passing a record instead of an unscoped ID prevents the
operator from duplicating tenant resolution.

Operators do not inherit from `Lesli::ApplicationLesliService`. The service
base provides CRUD state such as `query`, `resource`, `errors`, and
`successful?`; those concepts are not part of an operator's contract. Keep an
operator as a plain Ruby object until repeated behavior demonstrates the need
for a smaller shared abstraction. Services and operators are both application
objects, but their responsibilities differ; sharing a purpose does not require
sharing a superclass.

## Validating a Dataset

An operator can validate input before a later import without persisting it.
This example reuses the model's validations and returns errors by row:

```ruby
module MyEngine
    class UserOperator
        def initialize(account:)
            @account = account
        end

        def validate(rows)
            rows.each_with_index.filter_map do |attributes, index|
                user = @account.users.new(attributes)
                next if user.valid?

                { row: index + 1, errors: user.errors.full_messages }
            end
        end
    end
end

errors = MyEngine::UserOperator.new(account: current_user.account).validate(rows)
```

Here `rows` is an array of permitted attribute hashes, and `account` is a Core
account. An empty array means no validation errors were found. This performs
model validation only; database constraints still apply when records are
persisted. Do not put this batch operation in `UserService` or in a controller.

`UserOperator.validate(rows)` is also a valid Ruby API if the operation is
implemented as a stateless class method. Prefer an instance when it needs an
account, actor, or collaborators, as above. Keep the chosen API explicit and
consistent; no dispatcher or method registry is needed.

Operators define their own clear return value and expected failures. They do
not automatically provide `result`, `successful?`, or the service response
contract. Let unexpected errors propagate; handle expected failures at the
calling service or controller boundary.

## Using an Operator from a Service

A service can invoke an operator when a CRUD operation requires additional
domain work. The service owns the transaction because it coordinates the full
deletion workflow:

```ruby
def destroy
    Ticket.transaction do
        operator.cancel_pending_tasks!
        operator.remove_from_calendar!
        resource.destroy!
    end

    self
rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => exception
    error(exception.record.errors.full_messages.to_sentence)
    self
end

private

def operator
    @operator ||= TicketOperator.new(
        ticket: resource,
        actor: current_user
    )
end
```

Use `destroy!` for Lesli models that support soft deletion. It follows the
model lifecycle and sets `deleted_at`; it must not be used as a substitute for
a business action such as closing the ticket.

## Using an Operator from a Controller

A custom, non-CRUD route may resolve the resource through its service and then
invoke the operator directly:

```ruby
def close
    service = TicketService.new(current_user, query).find(id: params[:id])
    return respond_with_not_found unless service.found?

    ticket = TicketOperator.new(
        ticket: service.result,
        actor: current_user
    ).close!

    respond_with_lesli(
        turbo: stream_notification_success("Ticket closed"),
        json: ticket
    )
end
```

The controller owns the HTTP response, while the operator owns the complete
close transaction.

## When to Split an Operator

Begin with one operator per resource. Extract a separate operator only when:

* One operation becomes a substantial independent workflow.
* It requires collaborators unrelated to the other resource operations.
* The class is difficult to understand because it has too many responsibilities.

For example, `close!`, `reopen!`, and `assign!` can remain in
`TicketOperator`, while a complex import can become `TicketImportOperator`.

## Core Operators

Core provides two operators without a shared base class:

```ruby
# Register controller/action descriptors from installed routes.
Lesli::ResourceOperator.new.register!

# Provision or reconfigure an existing Core account.
operator = Lesli::AccountOperator.new(account: account)
operator.initialize_roles!
operator.initialize_engines!
```

Resource registration is transactional and preserves existing resource IDs on
repeated runs. It does not grant privileges itself. The `lesli:resources:build`
task invokes this operator; `Lesli::ResourceService.new(nil).index(matrix: true)`
remains the read API used by translation scanning.

Account creation still provisions its roles and installed engine workspaces
automatically. The existing model callbacks delegate to `AccountOperator`, so
console and seeder creation keep the same behavior. Database configuration
also invokes the operator. Each initialization method is transactional and
returns the account. Existing roles retain their configured defaults, and
existing engine accounts do not generate repeated initialization events.

`ResourceService#build` has been replaced by `ResourceOperator#register!`.
Account model initialization methods remain as callback delegation points.
