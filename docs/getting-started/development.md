# Install Lesli for development
The Lesli source code also is going to include the development tools to work with the Vue and SaaS applications.

### Install the Lesli core 

Clone the Lesli source code into your main Rails application, the Lesli engines needs to be installed inside the "engines" folder inside the main Rails application.

```text
Main Rails app/  
 ├── app/  
 ├── bin/  
 ├── config/  
 ├── db/  
 ├── engines/  
 ├── lib/  
 ├── log/  
 ├── public/  
 ├── spec/  
 ├── storage/  
 ├── tmp/  
 └── vendor/  
```

```shell
# Inside your Rails root folder
git clone git@github.com:LesliTech/Lesli.git engines/Lesli
```

Include Lesli into your Gemfile, be sure to load the engine from the source code using the "path" parameter.

```shell
gem "lesli", path: "engines/Lesli"
```


Install the gems needed by Lesli to work

```shell
bundle install
```

Lesli include a Rake task to start the database:

```shell
# Lesli include a Rake task to initialize the database for demo and development purposes, this task is going migrate, build privileges (if LesliSecurity is installed), translations (if LesliBabel is installed), seed the database with demo users and demo data for every installed engine and at the end print a pretty message with the status of the application.
rake lesli:db:dev

# or

# you can restart your database to start with a new fresh database
rake lesli:db:restart
```

Mount Lesli in your main Rails application

```ruby
Rails.application.routes.draw do
    mount Lesli::Engine => "/lesli"
end
```

Run the default Rails development server

```shell
rails s 
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```


### Logging into your new Lesli application
The seeders comes with default users with different roles and privileges, to see Lesli in action use the owner user:

__username:__ hello@lesli.tech 
__password:__ tardis2023$

> It is possible to add development users, roles, privileges and more; we will explore this options later in the documentation.
