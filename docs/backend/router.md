# Backend Routing

Lesli engines use standard Rails routes. The host application can mount every installed engine explicitly, or use `Lesli::Router` to mount the framework's known engines at their default paths.

The installation generator adds the router helper to `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  Lesli::Router.mount(self)
end
```

The helper defines the host application's root route. Use manual mounting if the host already owns `/` or needs a different root controller.

---

## Automatic Engine Mounting

`Lesli::Router.mount(self)` adds the Lesli welcome route, authentication routes, and a fixed mount point for each recognized engine whose constant is loaded.

| Engine | Default path |
| ------ | ------------ |
| Lesli Core | `/lesli` |
| LesliBell | `/bell` |
| LesliAdmin | `/admin` |
| LesliAudit | `/audit` |
| LesliBabel | `/babel` |
| LesliMailer | `/mailer` |
| LesliShield | `/shield` |
| LesliPapers | `/papers` |
| LesliSupport | `/support` |
| LesliSecurity | `/security` |
| LesliCalendar | `/calendar` |
| LesliContacts | `/contacts` |
| LesliDashboard | `/dashboard` |

The helper checks whether each engine constant is defined before mounting it. Installing or requiring an engine is still the application's responsibility.

The second argument to `mount` changes the authentication prefix only; it does not change the engine paths in the table:

```ruby
Rails.application.routes.draw do
  Lesli::Router.mount(self, "account")
end
```

With LesliShield installed, this places the sign-in route at `/account/login` while the engine mount points remain unchanged.

---

## Manual Engine Mounting

Mount engines manually when the application needs different URL prefixes or only a selected set of engines:

```ruby
Rails.application.routes.draw do
  root to: "lesli/abouts#welcome", as: :welcome

  mount Lesli::Engine => "/framework"
  mount LesliSupport::Engine => "/help-desk"
  mount LesliCalendar::Engine => "/schedule"
end
```

Only reference constants for gems that the application has installed. If an engine is optional, guard the mount:

```ruby
mount LesliAudit::Engine => "/audit" if defined?(LesliAudit)
```

Do not call `Lesli::Router.mount(self)` in the same route set when manually mounting the same engines, or Rails will receive duplicate routes.

---

## Authentication Routes

`Lesli::Router.login(self, path)` mounts authentication separately from the engine list:

```ruby
Rails.application.routes.draw do
  Lesli::Router.login(self, "account")
end
```

When LesliShield is installed, the helper delegates to `LesliShield::Router.mount_login_at` and provides these path names below the selected prefix:

* `login`
* `logout`
* `register`
* `password`
* `confirmation`

You can call the LesliShield helper directly when you are mounting the rest of the application manually:

```ruby
Rails.application.routes.draw do
  LesliShield::Router.mount_login_at(self, "account")
end
```

Without LesliShield, Lesli falls back to the standard Devise route declaration for `Lesli::User`; that fallback uses Devise's default path names.

---

## Shared Engine Routes

An engine can opt into Lesli's common dashboard, item, and health routes:

```ruby
MyEngine::Engine.routes.draw do
  Lesli::Router.mount_lesli_engine_routes(self)
end
```

The helper declares:

* The engine root and singleton `dashboard` routes
* `items/tasks` routes for `create` and `update`
* An `items/discussions` route for `create`
* An `up` health-check route

Use this helper only when the engine provides the corresponding dashboard and item controllers.

Attachment routes are opt-in because the engine must also provide its concrete
attachment model and migration:

```ruby
MyEngine::Engine.routes.draw do
  Lesli::Router.mount_lesli_engine_routes(self, attachments: true)
end
```

This adds `items/attachments` routes for `index`, `create`, `show`, and
`destroy`.

---

## Inspect Routes

Use the Rails route inspector to verify the final route set:

```shell
bin/rails routes
bin/rails routes -g login
bin/rails routes -g support
```

Route output is the source of truth when host routes, Lesli helpers, and mounted engines are combined.
