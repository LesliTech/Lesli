<p align="center">
    <img width="200" alt="Lesli logo" src="./app/assets/images/lesli/brand/app-logo.svg" />
</p>

<h3 align="center">Ruby on Rails SaaS Development Framework.</h3>

<hr/>

## Introduction 

Lesli is a SaaS development framework designed to build highly scalable, secure and customizable software products.

Built-on top of Ruby on Rails, Postgres, Vuejs, Bulma, SASS and many more awesome open-source libraries, packages, gems and tools.

Lesli is completely open source and comes with features and tools that can save you years of development effort, additionally, our pre-built modules can seamlessly extend Lesli's functionality, allowing you to build your own SaaS in a matter of minutes.

<br />
<hr />
<p align="center">
Lesli is currently in alpha, but we're excited about the promising improvements coming soon!
</p>
<hr />
<br />
<br />

Lesli is officially released and supported as of version 5

> Lesli goes beyond being just a starter-kit, template, admin panel or dashboard. Lesli is a Ruby on Rails gem that you can use to build modules (a.k.a. engines) and standard Rails applications leveraging its robust set of built-in features, generators, components, and industry standards. With Lesli, you have the flexibility to extend existing functionalities or develop fully customized software tailored to your specific needs.


## Documentation
* [Roadmap](./docs/roadmap.md)
* [Core database](./docs/database.md)
* [Main documentation](https://www.lesli.dev/documentation/)


## Installation

__Get the latest stable version of Lesli__

```ruby
# Gemfile
gem "lesli"
```

__Run bundle install:__

```shell
bundle install
```

__Generate the init files:__

```shell
rails g lesli:install
```

__Load the database and demo data:__

```shell
rake rake lesli:db:setup
```

__Run server__
```shell
rails s # for development
rails s --binding=0.0.0.0 # debug in local network
RAILS_SERVE_STATIC_FILES=true rails s --environment=production # production mode
```

For more details about the installation check the official [documentation.](https://www.lesli.dev/documentation)



## Development 

__Get the latest version of Lesli source code__

```shell
# clone the lesli repo inside your engine folder: RailsApp/engines
git clone https://github.com/LesliTech/Lesli.git
```

__Load Lesli as a Gem__
```ruby
gem "lesli", path: "engines/Lesli"
```

__Install the necessary Gems to run Lesli:__

```shell
bundle install
```

__Work with the database:__

```shell
# Hard reset for development:
rake lesli:db:reset 
```

__Run server__
```shell
rails s 
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```


## License  
------
Software developed in [Guatemala](http://visitguatemala.com/) by [LesliTech](https://www.lesli.tech) distributed under the *General Public License v 3.0* you can read the full license [here](http://www.gnu.org/licenses/gpl-3.0.html)

<br>

<p align="center">
    <img alt="Lesli logo" width="100" src="./app/assets/images/lesli/brand/app-icon.svg" />
</p>
