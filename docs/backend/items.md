# Record Items

Lesli Items add small, reusable capabilities to an engine resource without
moving domain behavior into controllers. Core provides the abstract models,
concerns, controllers, and view contracts. Each engine owns its concrete item
models, tables, account association, routes, and allowlist of supported parent
resources.

The four public item types are:

| Item | Purpose | Public resource API |
| --- | --- | --- |
| Activity | Semantic timeline events | `record_activity!` |
| Task | A simple reversible to-do item | `add_task!` |
| Discussion | A linear plain-text comment | `add_comment!` |
| Attachment | A private file associated with a record | Active Record association and HTTP endpoints |

## Shared Ownership Contract

Include only the concerns that the resource supports:

```ruby
module MyEngine
  class Ticket < ApplicationRecord
    include Lesli::Items::Activities
    include Lesli::Items::Tasks
    include Lesli::Items::Discussions
    include Lesli::Items::Attachments

    belongs_to :account, class_name: "MyEngine::Account"
  end
end
```

Items always inherit their account from the parent resource. The default
implementation returns `account`; override it only when the resource uses a
different ownership association:

```ruby
def lesli_item_account
  account
end
```

The default `lesli_item_accessible_by?` unwraps an engine account through its
`account` association and compares the resulting Core account with
`user.account`. An engine may override the method for a stricter policy. The
shared controllers return not found when the parent type is not allowlisted,
the record does not exist, or the user cannot access it.

Every concrete item model must declare its engine table and local account:

```ruby
module MyEngine
  module Items
    class Task < Lesli::Items::Task
      self.table_name = "my_engine_items_tasks"

      belongs_to :account, class_name: "MyEngine::Account"
    end
  end
end
```

Do not point engine items directly at `Lesli::Account`. Keeping the local
engine account preserves the engine boundary while that account's `account`
association provides access to the Core workspace.

## Activity

Include `Lesli::Items::Activities`. By default, the concern resolves
`MyEngine::Items::Activity` and creates a polymorphic `activities` association
using `subject` as its interface. Customize it before use when necessary:

```ruby
lesli_activities_setup(
  use: "MyEngine::Items::Activity",
  as: :subject,
  association_name: :activity_history
)
```

Record a semantic event through the parent resource:

```ruby
activity = ticket.record_activity!(
  actor: current_user,
  code: :priority_changed,
  description: "Ticket priority changed",
  metadata: {
    from: previous_priority_id,
    to: ticket.priority_id
  },
  activity_type: :activity
)
```

Signature:

```ruby
record_activity!(
  actor:,
  code:,
  description: nil,
  metadata: {},
  activity_type: :activity
)
```

`actor` is a Core `Lesli::User`. `code` must be a semantic snake-case event
name. `metadata` must be a Hash and is the correct place for structured
`from`/`to` values. The association assigns `subject`; the method assigns the
engine account, persists with `create!`, and returns the created activity.
Invalid data raises `ActiveRecord::RecordInvalid`.

Activities are an operational resource timeline and are destroyed with their
subject. Use LesliAudit instead when events must survive resource deletion or
meet audit-retention requirements.

## Task

Include `Lesli::Items::Tasks`. The default concrete class is
`MyEngine::Items::Task`; the default polymorphic interface and association are
`taskable` and `tasks`:

```ruby
lesli_tasks_setup(
  use: "MyEngine::Items::Task",
  as: :taskable,
  association_name: :task_list
)
```

Create a task through its resource:

```ruby
task = ticket.add_task!(
  creator: current_user,
  title: "Follow up with customer"
)
```

Signature:

```ruby
add_task!(creator:, title:)
```

The method assigns the taskable through the configured association, obtains
the engine account through `lesli_item_account`, persists with `create!`, and
returns the task. The only domain validation is a non-blank title. Tasks do not
use soft deletion. The shared update action toggles `done`, so an accidental
completion can be reopened.

## Discussion

Include `Lesli::Items::Discussions`. The default concrete class is
`MyEngine::Items::Discussion`; the default polymorphic interface and
association are `discussable` and `discussions`:

```ruby
lesli_discussions_setup(
  use: "MyEngine::Items::Discussion",
  as: :discussable,
  association_name: :comments
)
```

Add a comment through its resource:

```ruby
comment = ticket.add_comment!(
  author: current_user,
  message: "Follow up with the customer"
)
```

Signature:

```ruby
add_comment!(author:, message:)
```

The method assigns the discussable, engine account, and Core author, persists
with `create!`, and returns the comment. Messages must contain non-blank plain
text. The shared component escapes markup and preserves line breaks; HTML,
replies, threads, editing, deletion, and soft deletion are intentionally not
part of this API.

## Attachment

Include `Lesli::Items::Attachments`. The concern resolves
`MyEngine::Items::Attachment`, creates a polymorphic `attachments` association,
and exposes `is_lesli_attachable?` for the shared integration:

```ruby
lesli_attachments_setup(
  use: "MyEngine::Items::Attachment",
  as: :attachable,
  association_name: :attachments
)
```

The public Ruby API is the configured Active Record association:

```ruby
attachment = ticket.attachments.create!(
  user: current_user,
  account: ticket.lesli_item_account,
  file: params[:file],
  label: "Signed agreement",
  category: "contracts"
)
```

The shared HTTP controller supports list, upload, download, and removal. An
engine controller must explicitly allow each supported parent class instead of
resolving a class from request parameters:

```ruby
module MyEngine
  module Items
    class AttachmentsController < Lesli::Items::AttachmentsController
      private

      def allowed_attachable_classes
        [MyEngine::Ticket]
      end
    end
  end
end
```

The standard controller and LesliView component expect the association name
`attachments`. A custom `association_name` is suitable for a custom integration
but also requires overriding the controller/component behavior that reads
`attachable.attachments`.

Attachments require one file, accept an optional label up to 255 characters
and category up to 100 characters, and default to 25 MB. The accepted content
types include common images, PDF, text, CSV, ZIP, and Microsoft Office files.
Override `lesli_attachment_max_file_size` or
`lesli_attachment_content_types` on the concrete attachment model when an
engine needs a different policy.

## Active Storage Requirement

Attachment metadata belongs to the engine item table, but the file uses Rails
Active Storage. The host application must install the three shared Active
Storage tables once:

```shell
bin/rails active_storage:install
bin/rails db:migrate
```

The host also owns `config/storage.yml`, credentials, provider dependencies,
and `config.active_storage.service`. Local disk requires no provider gem. AWS
S3 and Cloudflare R2 both use Active Storage's S3 adapter and require
`aws-sdk-s3` in the host application:

```shell
bundle add aws-sdk-s3
```

Cloudflare R2 additionally requires its account endpoint, `region: auto`, and
normally `force_path_style: true`. See the
[LesliSupport attachment guide](/engines/support/tickets/attachments/) for
complete S3-compatible configuration.

## Transactions and Errors

The bang APIs deliberately raise on invalid data. Wrap the resource change and
its activity in the same transaction when both must succeed or fail together:

```ruby
Ticket.transaction do
  ticket.update!(ticket_params)
  ticket.record_activity!(
    actor: current_user,
    code: :ticket_updated,
    metadata: { from: previous_values, to: ticket.saved_changes }
  )
end
```

Controllers should rescue `ActiveRecord::RecordInvalid` at the response
boundary and return an unprocessable response. Do not silently ignore a failed
item write when the item is part of the domain operation.
