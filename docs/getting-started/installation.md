<script setup>
import Browser from "../../../.vitepress/components/lesli-browser.vue"
</script>

# Install Lesli core
Lesli is a Ruby on Rails gem designed to seamlessly integrate with your application. It ensures complete isolation of code, database, and assets, preventing any interference with your main Ruby on Rails application.

### Rails application 

Create a new Rails application

```shell
rails new LesliApp
```

Navigate to the LesliApp folder
```shell
cd LesliApp
```

Add Lesli gem to your Rails app

```shell
bundle add lesli
```

Add some Lesli modules to your Rails app

```shell
bundle add lesli_shield     # Authentication & Authorization
bundle add lesli_security   # Role & Privilege management
bundle add lesli_calendar   # Nice calendar to play with
```

<br/>

### Database 

Open the database configuration file
`LesliApp/config/database.yml`

Add PostgreSQL as the main database (Currently Lesli is compatible only with PostgreSQL and SQLite)
```yml
default: &default
  adapter: postgresql
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: "db_dev"
  username: "db_user"
  password: "db_pass"

test:
  <<: *default
  database: "lesli-test"
  username: "db_user"
  password: "db_pass"
```

My recommendation is to use Rails Credentials or AWS Secret Manager

```yml
development:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :database) %>
  username: <%= Rails.application.credentials.dig(:db, :username) %>
  password: <%= Rails.application.credentials.dig(:db, :password) %>

test:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :database) %>
  username: <%= Rails.application.credentials.dig(:db, :username) %>
  password: <%= Rails.application.credentials.dig(:db, :password) %>

production:
  <<: *default
  port: <%= Rails.application.credentials.dig(:db, :port) %>
  host: <%= Rails.application.credentials.dig(:db, :host) %>
  database: <%= Rails.application.credentials.dig(:db, :database) %>
  username: <%= Rails.application.credentials.dig(:db, :username) %>
  password: <%= Rails.application.credentials.dig(:db, :password) %>
```

Create the database for Lesli

```shell
rails db:create
```

Lesli include a Rake task to initialize the database for demo and development purposes, this task is going migrate, build privileges (if LesliSecurity is installed), translations (if LesliBabel is installed), seed the database with demo users and demo data for every installed engine and at the end print a pretty message with the status of the application.

```shell
rake lesli:db:dev
```


<br/>

### Router 

Open the Rails routes file at: `LesliApp/config/routes.rb` and include the Lesli modules

```ruby
Rails.application.routes.draw do
    mount Lesli::Engine => "/lesli"
end
```


<br/>

### Run Lesli 

Execute the Rails server

```shell
rails server
```

Using your favorite web browser navigate to <a href="http://127.0.0.1:3000" targer="_blank">http://127.0.0.1:3000/login</a>, Lesli mounted devise at root level, so you already have an authentication engine working.

<browser url="login">
    <img src="/images/engines/security/screenshot-login.png">
</browser>

The seeders comes with default users with different roles and privileges, to see Lesli in action use the owner user:

__username:__ hello@lesli.tech <br/>
__password:__ Tardis2023$ 

::: info
It is possible to add development users, roles, privileges and more; we will explore this options later in the documentation.
:::
