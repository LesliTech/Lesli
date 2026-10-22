# Models

`Lesli::ApplicationLesliRecord` is the shared Active Record base for framework models. It is abstract, enables soft deletion through `acts_as_paranoid`, and provides a resource UID helper.

An engine can expose its own namespaced base class:

```ruby
module MyEngine
  class ApplicationRecord < Lesli::ApplicationLesliRecord
    self.abstract_class = true
  end
end
```

Resource models then inherit from the engine base:

```ruby
module MyEngine
  class Ticket < ApplicationRecord
    belongs_to :account, class_name: "Lesli::Account"
  end
end
```

---

## Soft Deletion

Models that inherit from `Lesli::ApplicationLesliRecord` use `acts_as_paranoid`. Their tables must contain a nullable `deleted_at` column:

```ruby
create_table :my_engine_tickets do |t|
  t.references :account, null: false, foreign_key: { to_table: :lesli_accounts }
  t.string :subject, null: false
  t.datetime :deleted_at
  t.timestamps
end

add_index :my_engine_tickets, :deleted_at
```

Calling `destroy` sets `deleted_at` instead of removing the row. Use the APIs provided by `acts_as_paranoid` when an application needs to inspect, restore, or permanently remove deleted records.

Do not add `acts_as_paranoid` again in every model when the engine base already inherits from `Lesli::ApplicationLesliRecord`.

---

## Resource UIDs

`generate_resource_uid` creates a short identifier from the current year and month plus random uppercase letters:

```ruby
before_create do
  self.uid ||= generate_resource_uid(prefix: "TKT", length: 6)
end
```

A generated value resembles `TKT-2610-ABCDEF`. Without a prefix it resembles `2610-ABCDEF`.

The helper generates a candidate; it does not verify uniqueness. Add a unique database index and retry collisions when the identifier is externally visible:

```ruby
add_index :my_engine_tickets, :uid, unique: true
```

---

## Account Ownership

Core resources belong directly to `Lesli::Account`. Resources owned by an
engine belong to that engine's account, while user references continue to use
`Lesli::User`:

```ruby
belongs_to :account, class_name: "MyEngine::Account"
belongs_to :user, class_name: "Lesli::User"
```

```ruby
current_user.account.my_engine.tickets.find_by(id: params[:id])
```

An `account_id` submitted by a client must not decide ownership. Derive the
engine account from the authenticated user's Core account.

---

## Engine Account Associations

Lesli Core exposes one association for each supported engine workspace:

```ruby
has_one :my_engine,
  class_name: "MyEngine::Account",
  foreign_key: :account_id,
  inverse_of: :account
```

The matching engine model owns the inverse association. An engine account is a
one-to-one workspace for the Core account, so its `account_id` must have a
unique database index and the model must mirror that constraint:

```ruby
module MyEngine
  class Account < ApplicationRecord
    belongs_to :account,
      class_name: "Lesli::Account",
      inverse_of: :my_engine

    validates :account_id, uniqueness: true
  end
end
```

Only initialize this workspace when the engine is installed. Keep
`class_name`, `foreign_key`, and `inverse_of` explicit at the Core/engine
boundary, and keep all user ownership on `Lesli::User`.

Do not add a direct association from the core account to an engine child table
when that table's `account_id` references the engine account. For example, if
`my_engine_tickets.account_id` references `my_engine_accounts.id`, query it
through the engine account:

```ruby
current_user.account.my_engine.tickets
```

A direct `current_user.account.tickets` association would compare a
`lesli_accounts.id` with a `my_engine_accounts.id`. Those independent IDs can
coincide and expose records belonging to another account.

---

## Item Concerns

Lesli provides concerns for resources that support tasks, discussions,
activities, or file attachments:

```ruby
module MyEngine
  class Ticket < ApplicationRecord
    include Lesli::Items::Tasks
    include Lesli::Items::Discussions
    include Lesli::Items::Activities
    include Lesli::Items::Attachments
  end
end
```

By default, each concern expects a matching namespaced model:

* `MyEngine::Items::Task`
* `MyEngine::Items::Discussion`
* `MyEngine::Items::Activity`
* `MyEngine::Items::Attachment`

The corresponding item tables and polymorphic columns must also exist. If an engine uses different classes or association names, call the concern's setup method with its `use`, `as`, or `association_name` options.

When `association_name` is customized, `record_activity!` writes through that
configured association:

```ruby
lesli_activities_setup(
  use: "MyEngine::Items::Activity",
  association_name: :activity_history
)
```

Activity records follow a shared ownership contract:

* `subject` is the resource affected by the event.
* `actor` is the `Lesli::User` who performed the event and is stored in
  `user_id`.
* `account` is the account record owned by the engine. The abstract activity
  model deliberately does not assume an account class.
* `activity_code` is a semantic snake-case event name such as
  `priority_changed`, not a database column name such as `priority_id`.

Every concrete activity model must declare its table explicitly:

```ruby
module MyEngine
  module Items
    class Activity < Lesli::Items::Activity
      self.table_name = "my_engine_items_activities"

      belongs_to :account, class_name: "MyEngine::Account"
    end
  end
end
```

Record activities through the parent resource. The association assigns the
polymorphic subject, and the method returns the persisted activity:

```ruby
activity = ticket.record_activity!(
  actor: current_user,
  code: :priority_changed,
  description: "Ticket priority changed",
  metadata: {
    from: previous_priority_id,
    to: ticket.priority_id
  }
)
```

`record_activity!` uses the account returned by `lesli_item_account` and raises
`ActiveRecord::RecordInvalid` when the actor, account, subject, code, type, or
metadata is invalid. Engine resources normally return their direct engine
account:

```ruby
def lesli_item_account
  account
end
```

Activities provide an operational timeline for a resource. They are removed
with their subject and should not be used as a substitute for an immutable
audit log. Use LesliAudit when records must survive resource deletion or meet
audit-retention requirements.

Task, discussion, activity, and attachment records belong to the same engine
account as their parent resource. Their abstract Core models deliberately do
not select an account class; every concrete engine item declares it.

A discussion is one linear comment, not a reply or a thread. Its `author` is a
Core `Lesli::User` stored in `user_id`, its `account` belongs to the engine, its
`discussable` is the polymorphic parent resource, and its `message` must contain
non-blank plain text. Messages are escaped when rendered and preserve line
breaks without interpreting HTML. Discussion tables do not include
`deleted_at` because the first version does not expose editing or deletion.

Create comments through the discussable resource. The concern assigns the
polymorphic resource and engine account, raises when the comment is invalid,
and returns the persisted comment:

```ruby
comment = ticket.add_comment!(
  author: current_user,
  message: "Follow up with the customer"
)
```

When an engine configures a different association name,
`lesli_discussions_setup` stores both the concrete class and association used by
`add_comment!`:

```ruby
lesli_discussions_setup(
  use: "MyEngine::Items::Discussion",
  association_name: :comments
)
```

Tasks require only a non-blank title as domain data. Their account comes from
the parent resource through `lesli_item_account`, and their user is always a
Core `Lesli::User`. Tasks do not use soft deletion, so their tables must not
include `deleted_at`. The shared routes expose task creation and completion;
there are no individual show, index, or deletion operations. The parent
resource supplies the task collection when its page is rendered. Completion is
reversible: the update endpoint toggles a task between completed and pending.

Create a task through the taskable resource. The concern assigns the
polymorphic resource and engine account automatically, raises when the task is
invalid, and returns the persisted task:

```ruby
task = ticket.add_task!(
  creator: current_user,
  title: "Follow up with customer"
)
```

If an engine uses a different association name, `lesli_tasks_setup` stores it
and `add_task!` continues to use the configured association:

```ruby
lesli_tasks_setup(
  use: "MyEngine::Items::Task",
  association_name: :task_list
)
```

Attachment models inherit from `Lesli::Items::Attachment` and use Active
Storage for the file body and technical metadata. The engine table stores the
engine account, Core uploader, polymorphic resource, label, and category:

```ruby
module MyEngine
  module Items
    class Attachment < Lesli::Items::Attachment
      self.table_name = "my_engine_items_attachments"

      belongs_to :account, class_name: "MyEngine::Account"
    end
  end
end
```

Install Active Storage once in the host application, not once per engine:

```shell
bin/rails active_storage:install
bin/rails db:migrate
```

The shared item concerns obtain ownership from `lesli_item_account`, which
returns the parent resource's direct account by default. Access checks unwrap
that engine account to its owning `Lesli::Account` when comparing it with the
authenticated user. Override these methods only when a resource uses a
different ownership model.

Include only the concerns for which the engine provides the required models and migrations; missing item classes cause model loading to fail.
