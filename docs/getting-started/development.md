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

For local development, Lesli and its engines should live inside an `engines/` directory at the root of your Rails application.

> **Important**
> This directory structure is required for Lesli to detect and load its components correctly during development and runtime.

### Recommended Directory Structure

```text
Main Rails App/
├── app/
├── bin/
├── config/
├── db/
├── engines/
│   ├── Lesli/
│   ├── lesli_shield/
│   ├── lesli_dashboard/
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
git clone git@github.com:LesliTech/Lesli.git engines/Lesli
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

Once Lesli is loaded from source, continue with the regular installation process:

* Run the Lesli installer
* Prepare the database
* Run Lesli development tasks
* Start the Rails server

See the main installation guide for the remaining steps:

[Standard Installation Guide](https://www.lesli.dev/engines/lesli/getting-started/installation/)

---

## Summary

The only difference between a standard installation and a development installation is how the `lesli` gem is loaded.

* **Standard installation** uses the published gem
* **Development installation** uses a local clone of the framework source code

After that, the rest of the setup is the same.
