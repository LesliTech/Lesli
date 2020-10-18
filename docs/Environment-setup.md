<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h3 align="center">Environment setup</h3>

<hr/>


#### Development
-------


__Run server__
```shell
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```


__Work with git and github:__
```shell
rake dev:git:push
rake dev:git:pull
rake dev:git:add_origin
```


__Work with the database:__
```shell
rake dev:db:reset
```


__Work with Rails credentials:__
```shell

Ubuntu:
EDITOR="code --wait" rails credentials:edit --environment development
EDITOR="code --wait" rails credentials:edit --environment production
EDITOR="code --wait" rails credentials:edit --environment test
EDITOR="code --wait" rails credentials:edit

MacOS/Ubuntu server:
EDITOR="nano" rails credentials:edit --environment development
EDITOR="nano" rails credentials:edit --environment production
EDITOR="nano" rails credentials:edit --environment test
EDITOR="nano" rails credentials:edit
````


__Credentail file example:__
```
RailsApp/config/credentials/development.yml  

db:
    database: ""
    username: ""
    password: ""
    host: "" # optional
    port: "" # optional
services:
    jwt:
        secret: "your-secret-json-web-token-key"
providers:
    aws:
        region: eu-central-1
        bucket: ""
        access_key_id: ""
        secret_access_key: ""
        s3: (optional)
            access_key_id: ""
            secret_access_key: ""
        ses: (optional sdk or stmp)
            access_key_id: ""
            secret_access_key: ""
        sns: (optional)
            access_key_id: ""
            secret_access_key: ""
    google:
        maps_sdk_token: ""
    honey_badger:
        api_key: ""
    mailgun:
        smtp:
            port: 587
            address: "smtp.mailgun.org"
            user_name: ""
            password: ""
secret_key_base: "your-secret-key-base"
```


__Work with the database:__
```shell
Hard reset for development:
rake dev:db:reset 

Test production database:
rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production 
rake app:deploy:after RAILS_ENV=production
```


__Work with assets__
```shell
Development:
bundle exec rake assets:clean 
bundle exec rake assets:precompile 
bundle exec rake i18n:js:export 

Production:
bundle exec rake assets:clean RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
bundle exec rake i18n:js:export RAILS_ENV=production
```
