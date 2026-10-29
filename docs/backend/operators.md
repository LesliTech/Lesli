# Operators

Operators implement named operations that are not part of a resource's CRUD
lifecycle. They are useful for state transitions, data processing, imports,
notifications, and workflows involving more than one model.

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

Use `!` for methods that persist records or raise when they cannot complete.
Predicates should describe the decision they answer:

```ruby
operator.closable?
operator.assignable_to?(user)
```

Avoid generic names such as `validate` or `notify` when the specific intent can
be expressed as `validate_closure!` or `notify_owner!`.

## Construction

Pass the already scoped resource and the dependencies required by the
operation:

```ruby
TicketOperator.new(
  ticket: ticket,
  actor: current_user
)
```

Account-scoped lookup belongs to the resource service. Passing a record instead
of an unscoped ID prevents the operator from duplicating tenant resolution.

Operators do not inherit from `Lesli::ApplicationLesliService`. The service
base provides CRUD state such as `query`, `resource`, `failures`, and
`successful?`; those concepts are not part of an operator's contract. Keep an
operator as a plain Ruby object until repeated behavior demonstrates the need
for a smaller shared abstraction.

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
rescue ActiveRecord::RecordInvalid => exception
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
