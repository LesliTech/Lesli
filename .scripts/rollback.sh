#!/bin/bash

echo "Changing directories to wwww"
cd /var/www

echo "Removing current version"
rm -r ./lesli

echo "Moving previous version to current"
mv -v ./lesli_previous ./lesli

echo "Updating Gems"
cd ../../
bundle update

echo "Restarting server"
sudo service nginx restart

echo "Basic Deploy Completed. Remember to run any extra tasks written in Trello manually"

