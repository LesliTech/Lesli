<p align="center">
    <img width="200" alt="Lesli logo" src="./app/assets/images/lesli/brand/app-logo.svg" />
</p>

<h3 align="center">Your Smart Business Assistant</h3>

<hr/>

Version 3

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

# Restore database with a dump file
```

__Run server__

```bash
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```


### Documentation
* [Database](./docs/database.md)
* [Environment setup](./docs/entironment-setup.md)
* [Core resources](./docs/core-resources.md)



### License
-------
Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

<br>

<p align="center">
    <img alt="Lesli logo" width="100" src="./app/assets/images/lesli/brand/app-icon.svg" />
</p>
