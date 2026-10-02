# Installing Lesli for Development

This guide explains how to install **Lesli from source** for local development.

It follows the same general flow as the standard installation process, but instead of using the published gem, you will clone the Lesli repository and load it directly from your local filesystem.

This setup is recommended if you want to:

* Work with the latest framework changes
* Contribute to Lesli
* Debug or extend core functionality
* Develop custom engines alongside the framework

---

## Development Setup

The standard Lesli development workspace keeps Lesli and its engines inside an `engines/` directory at the root of the host Rails application. Using this convention keeps local Gemfile paths and framework tooling consistent.

> **Important**
> The repositories still need to be declared in your `Gemfile`. Their directory location alone does not load them into the application.

### Recommended Directory Structure

```text
Main Rails App/
├── app/
├── bin/
├── config/
├── db/
├── engines/
│   ├── Lesli/
│   ├── LesliShield/
│   ├── LesliDashboard/
│   └── ...
├── lib/
├── log/
├── public/
├── spec/
├── storage/
├── tmp/
└── vendor/
```

---

## Clone the Lesli Core Repository

From the root of your Rails application, clone the Lesli core repository into the `engines/` directory:

```bash
mkdir -p engines
git clone https://github.com/LesliTech/Lesli.git engines/Lesli
```

---

## Load Lesli from the Local Path

Update your `Gemfile` so Bundler loads Lesli directly from the local source code:

```ruby
gem "lesli", path: "engines/Lesli"
```

Then install dependencies:

```bash
bundle install
```

---

## Complete the Standard Installation

Once Lesli is loaded from source, initialize it and start the host application:

```shell
bin/rails generate lesli:install
bin/rails lesli:db:prepare
bin/rails server
```

See the main installation guide for the remaining steps:

[Standard Installation Guide](/engines/lesli/start/installation/)

---

## Summary

For core development, the main difference from a standard installation is how the `lesli` gem is loaded.

* **Standard installation** uses the published gem
* **Development installation** uses a local clone of the framework source code

The rest of the installation flow is the same. If you also need to modify a Lesli engine or supporting gem, clone that repository into `engines/` or `gems/` and add its local path to the host application's `Gemfile`.
