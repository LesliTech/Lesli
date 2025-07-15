
# Installation

Lesli is a Ruby on Rails gem designed to integrate seamlessly into your application. It keeps its code, database, and assets fully isolated, ensuring it won’t interfere with your main app. This isolation allows you to extend functionality without adding complexity or risking conflicts within your core codebase.


### Install Lesli 

Create a New Rails Application

```shell
rails new LesliApp
```

Navigate to the app directory:

```shell
cd LesliApp
```

Add Lesli to Your Gemfile

```shell
bundle add lesli
```

<br/>

### Set Up Lesli

After installing the gem, run the installation generator to configure the necessary files and routes:

```shell
rails generate lesli:install
```

This command will: 

- Create the initializer file for Lesli.
- Add the required route to your routes.rb.

<br/>

### Database Setup

Lesli includes a Rake task to prepare the database for demo and development purposes. This task will: 

- Run migrations.
- Set up privileges (if LesliShield is installed).
- Load translations (if LesliBabel is installed).
- Seed the database with demo users and demo data for each installed engine.
- Display a summary message with the application status.

```shell
rake lesli:db:dev
```

<br/>

### Running Lesli

Start the Rails server:

```shell
rails server
```

Using your favorite web browser navigate to <a href="http://127.0.0.1:3000" targer="_blank">http://127.0.0.1:3000/login</a>

<lesli-browser host="http://localhost:3000/" url="">
    <img src="/images/engines/lesli/screenshot-installation.png">
</lesli-browser>

You must be able to see the Lesli welcome page


<br/>

### Adding More Engines to Lesli

Lesli is designed to be extended through additional engines. These engines work as modular components to add features without affecting your core application.

Below is an example of how to install some of the official Lesli engines.


<br/>

### Install the Engines

Add the desired engines to your Gemfile:

```ruby
gem 'lesli_shield'
gem 'lesli_dashboard'
```

Then run:

```shell
bundle install
```


<br/>

### Update the Database

Lesli includes a Rake task to load new engines: 

```shell
rake lesli:db:setup
```

This will: 

- Apply migrations for each installed engine.
- Seed demo data, including privileges (for LesliShield) and dashboard components (for LesliDashboard).

> You can easily add development users, roles, privileges, and more. We'll cover these options later in the documentation.


<br/>

### Accessing the Engines

#### LesliShield

LesliShield provides user roles, privileges, and authentication tools. After installation, it integrates into your app’s authentication and permission layers automatically.
LesliDashboard

#### LesliDashboard 

LesliDashboard provides a customizable dashboard for users to visualize key data, metrics, or tools from other engines.

<lesli-browser host="http://localhost:3000/" url="login">
    <img src="/images/engines/shield/screenshot-login.png">
</lesli-browser>

> Lesli mounts Devise at the root level, so you’ll have an authentication system working out of the box.
