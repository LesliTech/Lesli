
# Install Lesli 
Lesli is a Ruby on Rails gem built to integrate smoothly into your application. It keeps its code, database, and assets fully isolated, so it won’t interfere with your main app. This makes it easy to extend functionality without creating conflicts or adding complexity to your core codebase.

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

Additional for this example we are going to install some other engines, so you can see the Lesli Platform working

```shell
bundle add lesli_shield
bundle add lesli_dashboard
```

Create the database for Lesli

```shell
rails db:create
```

Lesli include a Rake task to initialize the database for demo and development purposes, this task is going migrate, build privileges (if LesliShield is installed), translations (if LesliBabel is installed), seed the database with demo users and demo data for every installed engine and at the end print a pretty message with the status of the application.

```shell
rake lesli:db:dev
```


<br/>

### Router 

Open the Rails routes file at: `LesliApp/config/routes.rb` and include the Lesli modules

```ruby
Rails.application.routes.draw do
    # mount lesli platform
    Lesli::Routing.mount
end
```


<br/>

### Run Lesli 

Execute the Rails server

```shell
rails server
```

Using your favorite web browser navigate to <a href="http://127.0.0.1:3000" targer="_blank">http://127.0.0.1:3000/login</a>, Lesli mounted devise at root level, so you already have an authentication engine working.

<lesli-browser host="http://localhost:3000/" url="login">
    <img src="/images/engines/shield/screenshot-login.png">
</lesli-browser>

The seeders comes with default users with different roles and privileges, to see Lesli in action use the owner user:

__username:__ hello@lesli.tech <br/>
__password:__ Lesli123$


> It is possible to add development users, roles, privileges and more; we will explore this options later in the documentation.



