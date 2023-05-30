<!--
<p align="center">
    <img width="200" alt="Lesli logo" src="./app/assets/images/lesli/brand/app-logo.svg" />
</p>

<h3 align="center">Ruby on Rails SaaS development platform.</h3>
-->

![](./docs/screenshot.png)

<hr/>

## Introduction 

Lesli is a SaaS development platform designed to build highly scalable, secure and customizable software products.

Built-on top of Ruby on Rails, Postgres, Vuejs, Bulma, SASS and many more awesome open-source libraries, packages, gems and tools.

Lesli is completely open source and comes with features and tools that can save you years of development effort, also you can use our ready-made modules to extend the functionality of Lesli, so you can build your own SaaS in just minutes.

Lesli is officially released and supported as of version 4

> Lesli is not a starter-kit or a template, Lesli is a Ruby on Rails core where you can build modules (a.k.a. engines), using the built-in features, generators, components and standards to extend the functionalities or create full custom software.


## Installation

__Get the latest stable version of Lesli__

```shell
    git clone --branch production https://github.com/LesliTech/Lesli.git
```

__Install the necessary Gems to run Lesli:__

```shell
bundle install
```

__Add the credentials for the database:__

```shell
# MacOS/Ubuntu:
EDITOR="nano" rails credentials:edit --environment development
EDITOR="nano" rails credentials:edit --environment production
EDITOR="nano" rails credentials:edit --environment test
```

__Load the database and demo data:__

```bash
rake rake dev:db:setup
```

__Run server__
```bash
rails s # for development
rails s --binding=0.0.0.0 # debug in local network
RAILS_SERVE_STATIC_FILES=true rails s --environment=production # production mode
```

[For more details about the installation check the official documentation.](https://www.lesli.dev/documentation/getting-started/installation/)

## Development 

__Get the latest version of Lesli__

```shell
    git clone https://github.com/LesliTech/Lesli.git
```

__Install the necessary Gems to run Lesli:__

```shell
bundle install
```

__Work with Rails credentials:__

```bash
# Ubuntu:
EDITOR="code --wait" rails credentials:edit --environment development
EDITOR="code --wait" rails credentials:edit --environment production
EDITOR="code --wait" rails credentials:edit --environment test
EDITOR="code --wait" rails credentials:edit

# MacOS/Ubuntu server:
EDITOR="nano" rails credentials:edit --environment development
EDITOR="nano" rails credentials:edit --environment production
EDITOR="nano" rails credentials:edit --environment test
EDITOR="nano" rails credentials:edit
```

__Work with the database:__

```bash
# Hard reset for development:
rake dev:db:reset 
```

__Run server__
```bash
rails s 
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```


## Documentation
* [Core database](./docs/database.md)
* [Main documentation](https://www.lesli.dev/documentation/)


## License  
------
Software developed in [Guatemala](http://visitguatemala.com/) by [LesliTech](https://www.lesli.tech) distributed under the *General Public License v 3.0* you can read the full license [here](http://www.gnu.org/licenses/gpl-3.0.html)

<br>

<p align="center">
    <img alt="Lesli logo" width="100" src="./app/assets/images/lesli/brand/app-icon.svg" />
</p>
