# Installing Lesli for Development

Installing Lesli for development is very similar to the [standard installation process](https://www.lesli.dev/engines/lesli/getting-started/installation/) used for production.

However, instead of using the published gem, you'll clone the development repository and load the Lesli core directly from the source code. This approach is ideal for work with the latest features, contributing to Lesli, debugging core features, or customizing the framework for your own use.


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


From here, you can follow the instructions in the [official installation guide](https://www.lesli.dev/engines/lesli/getting-started/installation/) to complete your setup. 🙂

The rest of the steps—configuring the database, running Lesli's Rake tasks, and launching the server—are the same as a standard installation.
