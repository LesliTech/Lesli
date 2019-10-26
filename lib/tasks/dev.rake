namespace :dev do

    desc "Push everything to github master"
    task push: :environment do

        system "rm -r vendor/*"
        system "cp node_modules/bulma/ vendor/ -ra"
        system "cp node_modules/buefy/ vendor/ -ra"
        system "cp node_modules/lesli-css/ vendor/ -ra"
        system "cp node_modules/@fullcalendar/ vendor/ -ra"

        system "git add --all && git commit -m \"Updating vendors\""

        system "cd ./engines/CloudBell && git push github master"
        system "cd ./engines/CloudBooks && git push github master"
        system "cd ./engines/CloudCourier && git push github master"
        system "cd ./engines/CloudDriver && git push github master"
        system "cd ./engines/CloudHelp && git push github master"
        system "cd ./engines/CloudKb && git push github master"
        system "cd ./engines/CloudLesli && git push github master"
        system "cd ./engines/CloudLock && git push github master"
        system "cd ./engines/CloudPanel && git push github master"
        system "cd ./engines/CloudTeam && git push github master"
        
        system "git push github master"

    end

    desc "Database hard-reset"
    task reset: :environment do
        
        system "rails db:environment:set RAILS_ENV=development"
        system "rake db:drop RAILS_ENV=development" 
        system "rake db:create RAILS_ENV=development" 
        system "rake db:migrate RAILS_ENV=development" 
        system "rake db:seed RAILS_ENV=development" 

    end

    desc "LesliCloud fresh installation"
    task install: :environment do

        system "sudo service nginx stop"
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

        system "rvm use default"
        system "gem install bundler"
        system "bundle install"

        system "rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        system "rake db:create RAILS_ENV=production" 
        system "rake db:migrate RAILS_ENV=production" 
        system "rake db:seed RAILS_ENV=production" 

        system "bundle exec rake assets:clean RAILS_ENV=production"
        system "bundle exec rake assets:precompile RAILS_ENV=production"
        system "sudo service nginx restart"

    end

end
