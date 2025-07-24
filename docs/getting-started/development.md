# Installing Lesli for Development

Lesli provides a fully pre-configured environment optimized for working with modern Vue.js and SASS applications. It also includes a streamlined build process that compiles Vue components and SASS stylesheets into standard JavaScript and CSS assets.

> **Before You Start:**  
> Make sure you have **Ruby 3.2.x** and **Rails 8.0.x** installed on your system.


## Create a New Rails Application

To get started, generate a fresh Ruby on Rails app. This will serve as the base for integrating Lesli.

```bash
rails new LesliApp
```


### Install the Lesli Core

To get started with Lesli, clone the source code into your main Rails application.  
Lesli and its engines must be placed inside an `engines/` directory at the root of your Rails app.

> **Important:** This structure is required for Lesli to detect and load its components correctly during development and runtime.

#### Recommended Directory Structure

```text
Main Rails App/  
├── app/  
├── bin/  
├── config/  
├── db/  
├── engines/               ← Lesli and its engines live here!
│   ├── lesli/             ← The core Lesli gem
│   ├── lesli_shield/      ← Example engine: LesliShield
│   ├── lesli_dashboard/   ← Example engine: LesliDashboard
│   └── ...                ← Add more engines as needed
├── lib/  
├── log/  
├── public/  
├── spec/  
├── storage/  
├── tmp/  
└── vendor/
```

Clone the Lesli core repository into the `engines/` folder of your Rails application:

```bash
# Inside the root of your Rails app
git clone git@github.com:LesliTech/Lesli.git engines/Lesli
```

Tell Bundler to load Lesli directly from the local source code:

```shell
gem "lesli", path: "engines/Lesli"
```


Then install all required dependencies:

```bash
bundle install
```


Check that Lesli is correctly installed and accessible by running:

```bash
rake lesli:status
```

>This will output the current status of the Lesli framework and confirm that it's properly wired into your application.


Lesli provides a convenient Rake task to set up a fully functional database for development and demo purposes.

Run the following command:

```bash
rake lesli:db:dev
```

This task will:

- Run all database migrations 
- Build privileges (if LesliSecurity is installed) 
- Import translation files (if LesliBabel is installed) 
- Seed demo users and sample data for every installed engine 
- Output a summary with the current application status 
- You can restart your database to start with a new fresh database 

<br>

To reset your environment and start from a clean state, run:

```bash
rake lesli:db:restart
```
>This command will drop, create, migrate, and re-seed the database using the same logic as lesli:db:dev, Useful when testing or debugging your development setup.


To enable all Lesli engine routes, include the Lesli route builder inside your `config/routes.rb` file:

```ruby
Rails.application.routes.draw do
  Lesli::Routing.mount
end
```

Start the default Rails development server:

```shell
rails s 
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```

Using your favorite web browser, navigate to: <a href="http://127.0.0.1:3000/login" target="_blank">http://127.0.0.1:3000/login</a>

<lesli-browser host="http://localhost:3000/" url="">
  <img src="/images/engines/lesli/screenshot-welcome.png">
</lesli-browser>

You should now see the Lesli welcome page 🎉

---

### Recommendations

To improve your local development experience with Lesli, consider the following:

- **Use `letter_opener` for Local Email Preview**

<br>

Install the `letter_opener` gem in your `Gemfile` under the development group:

```ruby
group :development do
    gem 'letter_opener'
end
```

Then configure your config/environments/development.rb:

```ruby
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

This allows you to preview emails in your browser instead of sending them during development.
