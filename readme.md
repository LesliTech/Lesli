<p align="center">
    <img width="200" alt="Lesli logo" src="./app/assets/images/lesli/brand/app-logo.svg" />
</p>

<h3 align="center">Ruby on Rails SaaS development platform.</h3>

<hr/>

## Introduction 

Lesli is a SaaS development platform designed to build highly scalable, secure and customizable software products.

Built-on top of Ruby on Rails, Postgres, Vuejs, Bulma, SASS and many more awesome open-source libraries, packages, gems and tools.

Lesli is completely free, open source and comes with features and tools that can save you years of development effort, additionally, our pre-built modules can seamlessly extend Lesli's functionality, allowing you to build your own SaaS in a matter of minutes.

Lesli is officially released and supported as of version 4

> Lesli goes beyond being just a starter-kit or template. Lesli is a Ruby on Rails-based core that you can use to build modules (a.k.a. engines) leveraging its robust set of built-in features, generators, components, and industry standards. With Lesli, you have the flexibility to extend existing functionalities or develop fully customized software tailored to your specific needs.


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
* [Roadmap](./docs/roadmap.md)
* [Core database](./docs/database.md)
* [Main documentation](https://www.lesli.dev/documentation/)


## License  
------
Software developed in [Guatemala](http://visitguatemala.com/) by [LesliTech](https://www.lesli.tech) distributed under the *General Public License v 3.0* you can read the full license [here](http://www.gnu.org/licenses/gpl-3.0.html)

<br>

<p align="center">
    <img alt="Lesli logo" width="100" src="./app/assets/images/lesli/brand/app-icon.svg" />
</p>
