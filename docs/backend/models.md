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

Most engine resources belong to a Lesli account. Keep the association explicit and query through the current account in services:

```ruby
belongs_to :account, class_name: "Lesli::Account"
```

```ruby
current_user.account.my_engine.tickets.find_by(id: params[:id])
```

An `account_id` submitted by a client must not decide ownership. Derive the account from the authenticated user.

---

## Optional Engine Associations

Optional-engine associations are owned by the engine and should not be added
to Lesli Core. New and updated engines must use concerns to extend core models
such as `Lesli::Account` and `Lesli::User`; legacy direct declarations should
be migrated to this pattern. This keeps Core loadable when an engine is not
installed and keeps the association next to the models and tables it exposes.

Define the account extension inside the engine:

```ruby
module MyEngine
  module AccountAssociations
    extend ActiveSupport::Concern

    included do
      has_one :my_engine,
        class_name: "MyEngine::Account",
        foreign_key: :account_id,
        inverse_of: :account
    end
  end
end
```

Install it from the engine's reload-safe preparation block:

```ruby
config.to_prepare do
  unless Lesli::Account < MyEngine::AccountAssociations
    Lesli::Account.include(MyEngine::AccountAssociations)
  end
end
```

Use the same pattern with a separate concern when the engine extends
`Lesli::User`. Always make `class_name`, `foreign_key`, and `inverse_of`
explicit at this boundary.

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

Attachment models inherit from `Lesli::Items::Attachment` and use Active
Storage for the file body and technical metadata. The engine table stores the
Lesli account, uploader, polymorphic resource, label, and category:

```ruby
module MyEngine
  module Items
    class Attachment < Lesli::Items::Attachment
      self.table_name = "my_engine_items_attachments"
    end
  end
end
```

Install Active Storage once in the host application, not once per engine:

```shell
bin/rails active_storage:install
bin/rails db:migrate
```

An engine resource whose `account` points to an engine-specific account must
override `lesli_item_account` and return its owning `Lesli::Account`. This is
used to enforce tenant ownership when files are uploaded or downloaded.

Include only the concerns for which the engine provides the required models and migrations; missing item classes cause model loading to fail.
