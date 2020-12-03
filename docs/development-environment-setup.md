<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h3 align="center">Environment setup</h3>

<hr/>


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


__Notes:__

It seems that the latest version of XCode tools (12 Beta 3) installs a version of Clang (the C compiler used by default on MacOS) that throws an error on implicit functions used on the native extension code of Puma.  
  
Try running:  
```shell
bundle config build.puma --with-cflags="-Wno-error=implicit-function-declaration"
bundle install
````


__Install pg gem__
Sometimes pg gem trigger an error when the entire posgres server is not installed on the same server, to resolve this error run:  

```shell
sudo apt-get -y install libpq-dev
```


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
            region: eu-central-1
            bucket: ""
            access_key_id: ""
            secret_access_key: ""
        ses: (optional sdk or stmp)
            access_key_id: ""
            secret_access_key: ""
        sns: (optional)
            region: eu-central-1
            access_key_id: ""
            secret_access_key: ""
    google:
        maps_sdk_token: ""
    honey_badger:
        api_key: ""
        personal_token: ""
    mailgun:
        smtp:
            port: 587
            address: "smtp.mailgun.org"
            user_name: ""
            password: ""
secret_key_base: "your-secret-key-base"
```

__NGINX Virtual Host:__
```
server {

    root /var/www/lesli/public;

    client_max_body_size 120M;

    index index.html index.htm index.nginx-debian.html;

    server_name dev.lesli.cloud;

    passenger_enabled on;
    passenger_ruby /home/ubuntu/.rvm/gems/ruby-2.7.0/wrappers/ruby;

}
````

Enable website:  
`ln -s /etc/nginx/sites-available/leibrenten.leit.me.conf /etc/nginx/sites-enabled/leibrenten.leit.me.conf`

(Don't forget to install passenger ;))[https://www.phusionpassenger.com/docs/tutorials/deploy_to_production/installations/oss/aws/ruby/nginx/]

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

Restore database with a dump file

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
