# App installation

## Manual install

__Update production branch from origin__

```bash
# update the core
git pull origin production

# update the builder
cd engines/lesli_cloud 
git pull origin production
```


__Work with the database__

```bash
rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production
```


__Run maintenance tasks__

```bash
rake app:maintenance RAILS_ENV=production
```


__Change folder configuration__

```bash
# add writing permissions to public folder
sudo chmod 755 public/ -R

# make current logged user as owner of public folder
sudo chown ubuntu public/ -R

# make nginx user as owner of public folder
sudo chown www-data:www-data public/ -R

sudo chown www-data:www-data config/locales -R

sudo chmod 755 config/locales -R
```


__Work with assets__

```bash
# delete assets from old app versions
bundle exec rake assets:clean RAILS_ENV=production

# refresh assets
bundle exec rake assets:precompile RAILS_ENV=production

# create translations file to be used in the frontend
bundle exec rake i18n:js:export RAILS_ENV=production
```


__Work with nginx__

```bash

# check nginx configuration files
sudo service nginx -t

# 
sudo service nginx reload

# 
sudo service nginx force-reload

# restart nginx
sudo service nginx restart

```
