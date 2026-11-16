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
| Service | Account-scoped `index`, `list`, `show`, `create`, `update`, and `destroy` operations |
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

A resource service exposes CRUD operations and lightweight selector reads:

```ruby
TicketService#index
TicketService#list
TicketService#show
TicketService#create
TicketService#update
TicketService#destroy
```

`list` belongs in the service: it returns selector options, usually `id` and
`name`, while `index` provides the administrative listing. Both are reads, so
neither needs an operator.

Services own account-scoped lookup, persistence, and the standard Lesli result
contract. They may coordinate an operator when a CRUD action needs additional
work. `find` and the inherited result/error helpers support that contract; they
are not additional business operations. Private helpers may keep the CRUD
implementation readable. Do not add public workflow methods to the service.
See [Services](/engines/lesli/backend/services/).

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

Create a service for resource CRUD. Add an operator only when the resource
needs a non-CRUD operation; an empty operator is unnecessary. Split an operator
only when an operation becomes independently complex or no longer shares the
same resource and collaborators.

## Choosing the Right Layer

| Requirement | Location |
| --- | --- |
| Require a user's email on every save | Model validation |
| List, show, create, update, or delete a user | `UserService` CRUD method |
| Validate a dataset before importing it | `UserOperator#validate` |
| Import users, close a ticket, or send a notification | Named operator method |
| Permit input fields or choose an HTTP status | Controller |

Classify an operation by its purpose, not by the SQL it executes. An operator
may read or update records: closing a ticket is still a business operation,
even when its implementation uses `update!`. An ordinary edit of a resource's
attributes belongs in the service's `update` method.

These are the standards for new and revised code. Existing services may still
expose non-CRUD methods; move those operations to operators when updating their
consumers. This documentation does not change existing runtime APIs.
