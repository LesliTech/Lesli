<div align="center">
    <img width="150" alt="Lesli logo" src="./app/assets/images/lesli/lesli-logo.svg" />
    <h3 align="center">The Open-Source SaaS Development Framework for Ruby on Rails.</h3>
</div>

<br />
<hr/>

<div align="center">
    <a target="_blank" href="https://github.com/LesliTech/Lesli/actions">
        <img alt="Tests passing" src="https://img.shields.io/badge/Tests-passing-green?style=for-the-badge&logo=github">
    </a>
    <a target="_blank" href="https://rubygems.org/gems/lesli">
        <img alt="Gem Version" src="https://img.shields.io/gem/v/lesli?style=for-the-badge&logo=ruby">
    </a>
    <a target="_blank" href="https://codecov.io/github/LesliTech/Lesli">
        <img alt="Codecov" src="https://img.shields.io/codecov/c/github/LesliTech/Lesli?style=for-the-badge&logo=codecov">
    </a>
    <a target="_blank" href="https://sonarcloud.io/project/overview?id=LesliTech_Lesli">
        <img alt="Sonar Quality Gate" src="https://img.shields.io/sonar/quality_gate/LesliTech_Lesli?server=https%3A%2F%2Fsonarcloud.io&style=for-the-badge&logo=sonarqubecloud&label=Quality">
    </a>
</div>

<hr/>
<br />

<div align="center">
    <img
        style="width:100%;max-width:800px;border-radius:6px;"
        alt="Lesli screenshot" src="./docs/images/screenshot.png" />
</div>

---

## Introduction

Lesli is an open-source framework built to create scalable, secure, and modular software products.

Built on top of **Ruby on Rails, PostgreSQL, Hotwire, and modern frontend tooling**, Lesli provides the infrastructure, architecture, and reusable components needed to build production-ready SaaS platforms faster.

Lesli is not a starter kit, admin panel, or boilerplate.

It is a **modular foundation** that allows you to build applications using independent engines, shared infrastructure, and proven SaaS patterns.

With Lesli, you focus on features — not infrastructure.

---

## Why Lesli?

- Modular architecture powered by standard Rails engines  
- Flexible authentication, detailed privileges, and access control  
- System auditing with activities and version tracking  
- Attachments that can be added to any resource  
- Full-text search across modules and records  
- Multi-language support for both core and custom modules  
- Designed for long-term SaaS scalability and maintainability  

---

## Quick Start

```bash
# Create a new app using the Lesli template
rails new LesliDemo -m lesli_demo.rb --skip-bundle
```

### Manual installation

```shell
# Add Lesli
bundle add lesli

# Install Lesli
rails generate lesli:install

# Setup database
rake lesli:db:reset

# Start server
rails server
```

### Development 

```shell
# clone the lesli repo inside your engine folder: RailsApp/engines
git clone https://github.com/LesliTech/Lesli.git

# Load Lesli as a Gem
gem "lesli", path: "engines/Lesli"

# Install the necessary Gems to run Lesli
bundle install

# Generate Lesli initializer
rails generate lesli:install

# Hard reset Database for development:
rake lesli:db:reset 

# Run default Rails server
rails s 
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```

---

### Demo

* [online demo](https://demo.lesli.dev/)
* [docker demo](https://github.com/LesliTech/lesli-docker-demo)


### Documentation
* [website](https://www.lesli.dev/)
* [documentation](https://www.lesli.dev/lesli/)


### Connect with Lesli

* [X: @LesliTech](https://x.com/LesliTech)
* [Email: hello@lesli.tech](hello@lesli.tech)
* [Website: https://www.lesli.tech](https://www.lesli.tech)


### License
-------
Copyright (c) 2026, Lesli Technologies, S. A.

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
    <h3 align="center" class="mt-0">
        The Open-Source SaaS Development Framework for Ruby on Rails.
    </h3>
</div>

<br />
<br />
