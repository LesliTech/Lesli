# Snippets



__Run server__

```bash
rails s --environment=test
rails s --environment=development
RAILS_SERVE_STATIC_FILES=true rails s --environment=production 
```



__Work with git and github:__ 

```bash
rake dev:git:push
rake dev:git:pull
rake dev:git:add_origin
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
````



__Work with the database:__

```bash
# Hard reset for development:
rake dev:db:reset 

# Test production database:
rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production 
rake app:deploy:after RAILS_ENV=production

# Restore database with a dump file
```



__Work with assets__

```bash
# Development:
bundle exec rake assets:clean 
bundle exec rake assets:precompile 
bundle exec rake i18n:js:export 

# Production:
bundle exec rake assets:clean RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
bundle exec rake i18n:js:export RAILS_ENV=production
```


__Work with file system__

```bash
# copy remote credentials (example)
scp -i app.mitwerken.de.pem ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.key production.key
scp -i app.mitwerken.de.pem ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.yml.enc production.yml.enc

scp -i app.mitwerken.de.pem production.key ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.key
scp -i app.mitwerken.de.pem production.yml.enc ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.yml.enc


# search for the largest file and sort the result by size
du -chs engines/**/app/assets/javascripts/**/*.js app/assets/javascripts/**/*.js | sort -h

# search for the largest file in the inmediate child directory and sort the result by size
du -chs */*.* | sort -h

# find the 5 largest files (ubuntu only)
find . -type f -printf "%s\t%p\n" | sort -n | tail -5

# find the largest files in a folder (Mac & Ubuntu)
find public/assets -type f -exec du -h {} + | sort -h
```




### General troubleshooting 


__Install pg gem__
Sometimes pg gem trigger an error when the entire posgres server is not installed on the same server, to resolve this error run:  

```bash
sudo apt-get -y install libpq-dev
```


__Error running puma__
It seems that the latest version of XCode tools (12 Beta 3) installs a version of Clang (the C compiler used by default on MacOS) that throws an error on implicit functions used on the native extension code of Puma.  
  
Try running:  

```bash
bundle config build.puma --with-cflags="-Wno-error=implicit-function-declaration"
bundle install
````

