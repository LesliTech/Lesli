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

## Item Concerns

Lesli provides concerns for resources that support tasks, discussions, or activities:

```ruby
module MyEngine
  class Ticket < ApplicationRecord
    include Lesli::Items::Tasks
    include Lesli::Items::Discussions
    include Lesli::Items::Activities
  end
end
```

By default, each concern expects a matching namespaced model:

* `MyEngine::Items::Task`
* `MyEngine::Items::Discussion`
* `MyEngine::Items::Activity`

The corresponding item tables and polymorphic columns must also exist. If an engine uses different classes or association names, call the concern's setup method with its `use`, `as`, or `association_name` options.

Include only the concerns for which the engine provides the required models and migrations; missing item classes cause model loading to fail.
