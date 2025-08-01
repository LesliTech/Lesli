<div align="center" class="documentation-header">
    <img width="150" alt="Lesli logo" src="./app/assets/images/lesli/lesli-logo.svg" />
    <h3 align="center">Ruby on Rails SaaS Development Framework.</h3>
</div>


<br />
<hr/>

<div align="center" class="documentation-statics">
    <a target="blank" href="https://rubygems.org/gems/lesli">
        <img height="22" alt="Gem Version" src="https://badge.fury.io/rb/lesli.svg"/>
    </a>
    <a class="mx-2" href="https://codecov.io/github/LesliTech/Lesli"> 
        <img height="22" src="https://codecov.io/github/LesliTech/Lesli/graph/badge.svg?token=2O12NENK5Y"/> 
    </a>
    <a href="https://codecov.io/github/LesliTech/LesliBabel"> 
        <img height="22" src="https://sonarcloud.io/api/project_badges/measure?project=LesliTech_LesliBabel&metric=sqale_rating"/> 
    </a>
</div>

<hr/>
<br />

<div align="center">
    <img 
        style="width:100%;max-width:800px;border-radius:6px;" 
        alt="Lesli screenshot" src="./docs/images/screenshot.png" />
</div>


### Introduction 

Lesli is a SaaS development framework designed to build highly scalable, secure and customizable software products.

Built-on top of Ruby on Rails, Postgres, Hotwire, Bulma, SASS and many more awesome open-source libraries, packages, gems and tools.

Lesli is completely open source and comes with features and tools that can save you years of development effort, additionally, our pre-built modules can seamlessly extend Lesli's functionality, allowing you to build your own SaaS in a matter of minutes.

<br />
<hr />
<p align="center" class="has-text-centered">
    Lesli is currently in alpha, but we're excited about the promising improvements coming soon!
</p>
<hr />
<br />
<br />

Lesli is officially released and will be supported as of version 5.1

<br />

> Lesli goes beyond being just a starter-kit, template, admin panel or dashboard. Lesli is a Ruby on Rails gem that you can use to build modules (a.k.a. engines) and standard Rails applications leveraging its robust set of built-in features, generators, components, and industry standards. With Lesli, you have the flexibility to extend existing functionalities or develop fully customized software tailored to your specific needs.

<br />



### Demo

* [online demo](https://demo.lesli.dev/)
* [docker demo](https://github.com/LesliTech/lesli-docker-demo)

<br />



### Quick start

```shell
# Add Lesli engine
bundle add lesli
```

```shell
# Add Lesli to your app
rails generate lesli:install
```
```shell
# Setup database for development
rake lesli:db:dev
```
```shell
# Start your app
rails server
```


<br />



### Development 

```shell
# clone the lesli repo inside your engine folder: RailsApp/engines
git clone https://github.com/LesliTech/Lesli.git
```
```ruby
# Load Lesli as a Gem
gem "lesli", path: "engines/Lesli"
```
```shell
# Install the necessary Gems to run Lesli
bundle install
```
```shell
# Generate Lesli initializer
rails generate lesli:install
```
```shell
# Hard reset Database for development:
rake lesli:db:reset 
```
```shell
# Run default Rails server
rails s 
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```

<br />


### Lesli Documentation
* [website](https://www.lesli.dev/)
* [documentation](https://www.lesli.dev/lesli/)


### Get in touch with Lesli

* [X: @LesliTech](https://x.com/LesliTech)
* [Email: hello@lesli.tech](hello@lesli.tech)
* [Website: https://www.lesli.tech](https://www.lesli.tech)


### License
-------
Copyright (c) 2025, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

<hr />
<br />
<br />

<div align="center" class="has-text-centered">
    <img width="200" alt="Lesli logo" src="https://cdn.lesli.tech/lesli/brand/app-logo.svg" />
    <h4 align="center" class="mt-0">Ruby on Rails SaaS Development Framework.</h4>
</div>

<br />
<br />
