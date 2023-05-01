<p align="center">
    <img width="200" alt="Lesli logo" src="./app/assets/images/lesli/brand/app-logo.svg" />
</p>

<h3 align="center">Ruby on Rails high-level development platform.</h3>

<hr/>

Version 4

### Development 

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

# Test production database:
rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production 
rake app:maintenance RAILS_ENV=production
```

__Run server__
```bash
rails s --binding=0.0.0.0
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```


### Documentation
* [Database](./docs/database.md)
* [Environment setup](./docs/entironment-setup.md)
* [Core resources](./docs/core-resources.md)


### License  
------
Software developed in [Guatemala](http://visitguatemala.com/) by [LesliTech](https://www.lesli.tech) distributed under the *General Public License v 3.0* you can read the full license [here](http://www.gnu.org/licenses/gpl-3.0.html)

<br>

<p align="center">
    <img alt="Lesli logo" width="100" src="./app/assets/images/lesli/brand/app-icon.svg" />
</p>
