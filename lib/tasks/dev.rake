namespace :dev do

    namespace :git do

        desc "Push everything to github master"
        task push: :environment do

            [
                'CloudTeam',
                'CloudHappy',
                'CloudSeller',
                'CloudLeaf',
                'CloudDrop',
                'CloudMailer',
                'CloudDriver',
                'CloudChaos',
                'CloudClock',
                'CloudPizza',
                'CloudNotes',
                'CloudLesli',
                'CloudSocial',
                'CloudBell',
                'CloudBooks',
                'CloudWallet',
                'CloudThings',
                'CloudKb',
                'CloudHelp',
                'CloudPortal',
                'CloudBug',
                'CloudPanel',
                'CloudLock',
                'CloudBabel'
            ].each do |engine|
                engine_path = Rails.root.join('engines')# File.expand_path("./engines/#{engine}", __FILE__)
                p engine_path
                p '-     -     -     -     -     -     -     -     -     -     -     -     -     -     -'
                #system "cd ./engines/#{engine} && git push github master" if File.exists?(engine_path)
            end
            
            system "rm -r vendor/*"
            system "cp node_modules/buefy/ vendor/ -ra"
            system "cp node_modules/bulma/ vendor/ -ra"
            system "cp node_modules/bulma-extensions/ vendor/ -ra"
            system "cp node_modules/@fullcalendar/ vendor/ -ra"
            system "cp node_modules/lesli-css/ vendor/ -ra"

            system "git add --all && git commit -m \"Update vendors\""
            
            system "git push github master"

        end

        desc "Pull everything from github master"
        task pull: :environment do

            [
                'CloudTeam',
                'CloudHappy',
                'CloudSeller',
                'CloudLeaf',
                'CloudDrop',
                'CloudMailer',
                'CloudDriver',
                'CloudChaos',
                'CloudClock',
                'CloudPizza',
                'CloudNotes',
                'CloudLesli',
                'CloudSocial',
                'CloudBell',
                'CloudBooks',
                'CloudWallet',
                'CloudThings',
                'CloudKb',
                'CloudHelp',
                'CloudPortal',
                'CloudBug',
                'CloudPanel',
                'CloudLock',
                'CloudBabel'
            ].each do |engine|
                system "cd ./engines/#{engine} && git pull github master"
            end

            system "git pull github master"

        end

    end

    namespace :db do

        desc "Database hard-reset"
        task reset: :environment do
            
            system "rails db:environment:set RAILS_ENV=development"
            system "rake db:drop RAILS_ENV=development" 
            system "rake db:create RAILS_ENV=development" 
            system "rake db:migrate RAILS_ENV=development" 
            system "rake db:seed RAILS_ENV=development" 

        end

    end

    namespace :app do

        desc "LesliCloud fresh installation"
        task install: :environment do

            system "sudo service nginx stop"
            system "git checkout ."
            system "git pull origin master --no-edit"
            system "cd ./engines/CloudBell && git pull origin master --no-edit"
            system "cd ./engines/CloudBooks && git pull origin master --no-edit"
            system "cd ./engines/CloudCourier && git pull origin master --no-edit"
            system "cd ./engines/CloudDriver && git pull origin master --no-edit"
            system "cd ./engines/CloudHelp && git pull origin master --no-edit"
            system "cd ./engines/CloudKb && git pull origin master --no-edit"
            system "cd ./engines/CloudLesli && git pull origin master --no-edit"
            system "cd ./engines/CloudLock && git pull origin master --no-edit"
            system "cd ./engines/CloudPanel && git pull origin master --no-edit"
            system "cd ./engines/CloudTeam && git pull origin master --no-edit"

            #system "rvm use default"
            system "gem install bundler"
            system "bundle install"

            system "rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
            system "rake db:create RAILS_ENV=production" 
            system "rake db:migrate RAILS_ENV=production" 
            system "rake db:seed RAILS_ENV=production" 

            system "whenever --update-crontab"

            system "bundle exec rake assets:clean RAILS_ENV=production"
            system "bundle exec rake assets:precompile RAILS_ENV=production"
            
            system "sudo service nginx restart"

        end

    end

end
