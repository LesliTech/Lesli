# Upgrade development tools version
It is recommendable upgrade our develoment tools every few months, as standard we have to upgrade Ruby, Ruby on Rails and NPM libraries.

## Ruby upgrade

```sh
# first check the current ruby version 
ruby -v
# => 2.7.0

# to install the latest version using rvm
rvm install ruby 2.7.2

# uninstall the previous version to use the new version as default
rvm uninstall ruby-2.7.0

# due new version of ruby means new path for gems, install rails again
gem install rails # latest version

gem install rails -v 6.1.0 # specific version
```

after installations steps:

- change ruby version at:
    - lesli/.ruby-version
    - lesli/Gemfile

**IMPORTANT:** DO NOT forget to update the ruby version in the production servers nginx's virtual host files located at: */etc/nginx/sites-available/*



## Rails upgrade

- change rails version at:
    - lesli/Gemfile
    - engine/engine_name.gemspec

- check for gem updates
    - `bundle outdated`
    - update gems at lesli/Gemfile *DO NOT* forget to delete your local Gemfile.lock
    - install gems again `bundle install`

RoR provides a task that check and update configuration files

```sh
# run this command at core level: lesli/
bin/rails app:update
```

The RoR cli is going to ask you if you want to overwrite the current configuration files, this process is very important because you must allow the cli to overwrite the files and then add once again all the settings for the platform.  

The most important files are located are:
    - lesli/bin/rails (there is a custom constant defined here)
    - lesli/config/routes.rb
    - lesli/config/environments/development.rb
    - lesli/config/environments/production.rb  

For the environment files this process is easy because by default we keep the original configuration and we only have to add an aditional configuration block to override only the specific configuration we want to customize. In this case you just have to check if the config keys are the same or if there is a new setting that we want to change too.



## NPM packages upgrade

```sh
# check for available packages updates
npm outdated

# update the package version at lesli/package.json

# delete node_modules folder 
rm -rf node_modules

# install packages again
npm install
```
