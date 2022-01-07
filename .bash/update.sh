#!/bin/bash

# Copyright (c) 2021, all rights reserved.
#
# All the information provided by this platform is protected by international laws related  to 
# industrial property, intellectual property, copyright and relative international laws. 
# All intellectual or industrial property rights of the code, texts, trade mark, design, 
# pictures and any other information belongs to the owner of this platform.
#
# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.
#
# For more information read the license file including with this software.


# Git branch to work with
# production 
# master
# test
GIT_BRANCH=""


# 0 without change
# 1 migrate
# 2 reset
DATABASE_STATUS=0


# Initialize variables
APP_NAME="lesli.cloud"  # folder where the code is installed 
PATH_INSTALLATION=""    # path to nginx folder
PATH_BACKUP=""          # path to backup folder, usually is one folder up of the app_name
PATH_APP=""             # absolute path to code 


# Initialize constants
DATECURRENT=`date +"%Y/%m/%d %T"`   # current date and time in human format
DATEID=`date +"%Y%m%d-%s"`          # current date and timestamp used as id



# ask to the user for the installation path
# by default we use the standard path of nginx server
function set_installation_path() {

    # ask user for input
    read -p "Installation path: [/var/www/lesli.cloud]: " path

    # if input is nil, use standard path for nginx server
    path=${path:-"/var/www/lesli.cloud"}
    #path="/Users/ldonis/code/Lesli"

    # update global variables with givin path
    PATH_INSTALLATION="${path}"

    # ask user for app name
    read -p "App name: [app.lesli.cloud]: " name

    # if input is nil, use the default app name of the lesli.cloud server
    APP_NAME=${name:-"app.lesli.cloud"}

    # set global app installation path (absolute path to the code)
    PATH_APP=${PATH_INSTALLATION}"/"${APP_NAME}

    # set backup folder path
    PATH_BACKUP="../"${PATH_APP}"/RELEASES"

}



# Ask for the git branch to work with
# the options are:
#   - production
#   - master
#   - test
function set_git_branch() {
    PS3='Please enter your choice: '
    options=("production" "master" "test")
    select opt in "${options[@]}"
    do
        case $opt in
            "production")
                echo "production branch selected!"
                BRANCH="production"
                break
                ;;
            "master")
                echo "master branch selected!"
                BRANCH="master"
                break
                ;;
            "test")
                echo "master branch selected!"
                BRANCH="master"
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}



# create a backup of the previous working version of the code
function release_backup() {

    # folders to exclude from the backup
    ex1="${PATH_APP}/RELEASES"
    ex2="${PATH_APP}/.git"
    ex3="${PATH_APP}/tmp"

    # build the paths of the backup
    from=${PATH_INSTALLATION}"/"${APP_NAME}
    to=${PATH_BACKUP}"/"${DATEID}

    # create the backup folder (if does not exists)
    mkdir -p ${PATH_BACKUP}

    # compress the current working version of the code and compress to save as a backup
    tar -zcvf ${to}".tar.gz" --exclude={${ex1},${ex2},${ex3},"*.git*"} ${from}

    # TODO:
    #   - delete old backups
    #rm -rf ${BackupPath}${folder}

}



# update code from github
# the git branch was defined by the user
function git_update_code_core() {
    git reset --hard ${GIT_BRANCH}
    git checkout ${GIT_BRANCH}
    git pull origin ${GIT_BRANCH}
}



# reset any untracked change and switch to 
# the defined branch 
function git_update_code_engines() {
    cd engines/*/
    git reset --hard ${GIT_BRANCH}
    git checkout ${GIT_BRANCH}
    git pull origin ${GIT_BRANCH}
}



# run bundle updates 
function git_update_gems() {
    cd ../../
    bundle update
}



# ask to the user if wants to delete de database
function database_reset() {
    if [[ $(ask_yes_or_no "Do you want to reset the database?") == "yes" ]] 
    then
        bundle exec rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production
        bundle exec rake db:create RAILS_ENV=production
        bundle exec rake db:migrate RAILS_ENV=production
        bundle exec rake db:seed RAILS_ENV=production
        DATABASE_STATUS=2
    fi
}



# update database
function database_update() {
    echo $DATABASE_STATUS
    if [ $DATABASE_STATUS -gt 0 ]; then return; fi 
    bundle exec rake db:migrate RAILS_ENV=production
    DATABASE_STATUS=1
}



# run rake maintenance tasks
function rails_maintenance_tasks() {
    bundle exec rake app:controllers:build RAILS_ENV=production
    bundle exec rake cloud_babel:sync RAILS_ENV=production
    bundle exec rake cloud_babel:rails RAILS_ENV=production
}



# precompile assets
function rails_precompile_assets() {
    bundle exec rake assets:clean RAILS_ENV=production
    bundle exec rake assets:precompile RAILS_ENV=production
    bundle exec rake i18n:js:export RAILS_ENV=production
}



# touch the file to tell
function nginx_restart() {
    touch ./tmp/restart.txt
}



# save a log for every deploy
function log() {
    backupsize=`du -hs "${PATH_INSTALLATION}/${APP_NAME}"`
    echo "Backup ${DATECURRENT} - ${backupsize}:${GIT_BRANCH} completed." >> "${PATH_INSTALLATION}/${APP_NAME}/log/releases.log"
}



# 
function ask_yes_or_no() {
    read -p "$1 (Y/y) Yes or (N/n) No: "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}




# run tasks
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
set_installation_path
set_git_branch

release_backup

git_update_code_core
git_update_code_engines
git_update_gems

database_reset
database_update

rails_maintenance_tasks
rails_precompile_assets

nginx_restart

log
