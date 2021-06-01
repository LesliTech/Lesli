#!/bin/bash

echo "Changing directories to lesli"
cd /var/www/lesli

echo "Removing previous version"
rm -r ./lesli_previous

echo "Moving current version to previous"
rake deploy:execute RAILS_ENV=production

echo "Updating core"
git reset --hard production
git pull origin production

echo "Updating builder engine"
cd engines/*/
git pull origin production

echo "Updating Gems"
cd ../../
bundle update

echo "Running migrations"
rake db:migrate RAILS_ENV=production

echo "Building roles"
rake app:roles:build RAILS_ENV=production

echo "Scanning and building translations"
rake cloud_babel:sync RAILS_ENV=production
rake cloud_babel:rails RAILS_ENV=production

echo "Precompiling assets"
rake assets:precompile RAILS_ENV=production

echo "Restarting server"
sudo service nginx restart

echo "Basic Deploy Completed. Remember to run any extra tasks written in Trello manually"



