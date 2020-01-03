namespace :dev do

    namespace :app do

        desc "LesliCloud fresh installation"
        task install: :environment do

            system "sudo service nginx stop"
            system "git checkout ."
            system "git pull origin master --no-edit"
            
            Rake::Task["dev:git:pull"].invoke

            system "gem install bundler"
            system "bundle install"

            Rake::Task["dev:db:reset"].invoke

            system "whenever --update-crontab"

            system "bundle exec rake assets:clean RAILS_ENV=production"
            system "bundle exec rake assets:precompile RAILS_ENV=production"
            
            system "sudo service nginx restart"

        end

    end

end
