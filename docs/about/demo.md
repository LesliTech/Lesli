# Explore Lesli in Action

There are several ways to try Lesli, depending on how you prefer to evaluate new tools. You can use the public online demo, create a local demo app with a Rails template, or run the full Docker demo environment on your machine.

---

## Online Demo

Try Lesli instantly through the public demo instance:

[https://demo.lesli.dev](https://demo.lesli.dev)

> **Important**
> This is a public environment intended for evaluation only.
> LesliTech is not responsible for data stored in this instance.
> The demo is reset every 24 hours.

---

## Create a Demo App with a Rails Template

If you want to explore Lesli inside a fresh Rails application, you can generate a demo app with a Rails template:

```shell
rails new LesliDemo -m lesli_demo.rb --skip-bundle
```

This option is useful if you want a lightweight local environment for testing or learning how Lesli fits into a standard Rails application.

---

## Install Lesli Manually

If you prefer to install Lesli step by step, you can add it to your Rails application manually:

```shell
# Add Lesli
bundle add lesli

# Install Lesli into your app
rails generate lesli:install

# Prepare the development database
rake lesli:db:reset

# Start the application
rails server
```

This approach is recommended if you want to understand the installation process in detail.

---

## Run Lesli with Docker

You can also run a complete local demo environment with Docker:

```shell
# Clone the repository
git clone https://github.com/LesliTech/lesli-docker-demo.git

# Move into the project directory
cd lesli-docker-demo

# Start the demo environment
docker compose up --build
```

The Docker demo includes all official Lesli modules and sample data, making it the fastest way to explore the full platform locally.

---

## Log In to Your Local Instance

Once the application is running, open the following URL in your browser:

[http://127.0.0.1:3000](http://127.0.0.1:3000)

The demo environment includes default users with different roles and permissions. To explore the full platform, use the owner account:

**Username:** [hello@lesli.tech](mailto:hello@lesli.tech)
**Password:** Test123!

<lesli-browser host="http://localhost:3000/" url="login">
    <img src="/images/engines/shield/screenshot-login.png">
</lesli-browser>

> The Docker demo and Rails template include official Lesli modules and sample data for evaluation and testing.
