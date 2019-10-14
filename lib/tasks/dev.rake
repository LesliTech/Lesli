namespace :dev do

    desc "TODO"
    task push: :environment do

        system "rm -r vendor/*"
        system "cp node_modules/bulma/ vendor/ -ra"
        system "cp node_modules/buefy/ vendor/ -ra"
        system "cp node_modules/lesli-css/ vendor/ -ra"
        system "cp node_modules/@fullcalendar/ vendor/ -ra"
        system "git add --all && git commit -m \"Updating vendors\""

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudBell"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudBooks"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudCourier"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudDriver"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudHelp"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudKb"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudLesli"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudLock"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudPanel"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudTeam"
        system "git push github master"

        system "cd /var/www/LesliCloud/lesli.cloud"
        system "git push github master"

    end

    desc "TODO"
    task reset: :environment do
        
        system "rails db:environment:set RAILS_ENV=development"
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
        Rake::Task["db:seed"].invoke

    end

    desc "TODO"
    task install: :environment do

        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudBell"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudBooks"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudCourier"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudDriver"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudHelp"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudKb"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudLesli"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudLock"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudPanel"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud/engines/CloudTeam"
        system "git pull origin master --no-edit"

        system "cd /var/www/LesliCloud/lesli.cloud"

        system "rvm use default"
        system "gem install bundler"
        system "bundle install"

        system "rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
        Rake::Task["db:seed"].invoke

        system "bundle exec rake assets:clean RAILS_ENV=production"
        system "bundle exec rake assets:precompile RAILS_ENV=production"

        system "sudo service nginx restart"

    end

end
