namespace :dev do

    namespace :app do

        desc "LesliCloud fresh installation"
        task install: :environment do

            system "gem install bundler"
            system "bundle install"

            system "sudo service nginx stop"
            system "git checkout ."

            Rake::Task["dev:git:pull"].invoke

            system "rails db:environment:set RAILS_ENV=production"
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
