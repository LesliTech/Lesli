# Application Architecture

Lesli extends Rails MVC with two application-layer concepts: **Services** for
resource CRUD and **Operators** for business operations. The goal is to keep
HTTP behavior, persistence rules, CRUD orchestration, and domain actions easy
to locate without replacing Rails conventions.

```text
HTTP request
    |
Controller
    |-- Service  ------> Model ------> Database
    |      |
    |      `----------> Operator
    |
    `-- Operator -----> Model
```

Controllers use services for normal resource actions. A service may invoke an
operator when a CRUD operation requires additional domain work. A custom
controller action, job, or task may invoke an operator directly.

## Responsibilities

| Layer | Responsibility |
| --- | --- |
| Model | Associations, persistence invariants, validations, small scopes, and local callbacks |
| Controller | Authentication, authorization, parameters, HTTP formats, redirects, and status codes |
| Service | Account-scoped `index`, `show`, `create`, `update`, and `destroy` operations |
| Operator | Named non-CRUD operations such as `close!`, `reopen!`, `assign!`, or `notify_owner!` |

### Models

Models protect rules that must remain true regardless of how a record is
created. Keep callbacks local to the model's own persistence lifecycle. Do not
hide multi-model workflows, external integrations, or optional-engine behavior
inside callbacks.

### Controllers

Controllers translate HTTP into application calls. They may select a response
format, but services and operators must not render templates, construct Turbo
Streams, redirect, or depend on `ActionController::Parameters`.

### Services

One resource service exposes its CRUD lifecycle:

```ruby
TicketService#index
TicketService#show
TicketService#create
TicketService#update
TicketService#destroy
```

Services own account-scoped lookup, persistence, and the standard Lesli result
contract. They may coordinate an operator when a CRUD action needs additional
work. See [Services](/engines/lesli/backend/services/).

### Operators

One resource operator exposes explicit business actions:

```ruby
operator = TicketOperator.new(ticket: ticket, actor: current_user)

operator.close!
operator.reopen!
operator.notify_owner!
```

Operators are plain Ruby objects and do not inherit from
`Lesli::ApplicationLesliService`. Their methods return the operation result and
allow failures to propagate to the caller. See
[Operators](/engines/lesli/backend/operators/).

## CRUD and Business Actions

Do not use resource deletion to represent a business-state transition. For
example, closing a ticket keeps the record available and changes its lifecycle;
destroying it removes it from normal queries through soft deletion.

```text
PATCH  /tickets/:id/close  -> TicketOperator#close!
DELETE /tickets/:id        -> TicketService#destroy
```

The distinction keeps routes, audit events, restoration, and authorization
semantically clear.

## Dependency Direction

Keep dependencies moving toward models and external adapters:

```text
Controller -> Service -> Operator -> Model
Controller ------------> Operator -> Model
Job or task ------------> Operator -> Model
```

An operator must not call a resource service. This avoids circular orchestration
and keeps the owner of each operation clear.

## Transaction Ownership

The object coordinating the complete operation owns its transaction:

* An operator owns the transaction when it performs the complete business action.
* A service owns the transaction when it combines CRUD persistence with one or
  more operator methods.

Avoid splitting one atomic operation across independent transactions.

## Suggested Structure

```text
app/
├── controllers/my_engine/tickets_controller.rb
├── models/my_engine/ticket.rb
├── operators/my_engine/ticket_operator.rb
└── services/my_engine/ticket_service.rb
```

Start with one service and one operator per resource. Split an operator only
when an operation becomes independently complex or no longer shares the same
resource and collaborators.
