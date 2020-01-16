namespace :dev do

    namespace :app do

        desc "LesliCloud fresh installation"
        task install: :environment do

            datetime_start = Time.now.strftime('%Y/%m/%d %H:%M:%S')
            file = File.open(Rails.root.join("public", "dev-deploy-log.txt"), "a")
            file.write("Deploy process started at: #{ datetime_start }, ")
            file.close

            system "sudo service nginx stop"

            system "git checkout ."

            Rake::Task["dev:git:pull"].invoke

            system "gem install bundler"
            system "bundle install"

            system "rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production" 
            system "rake db:create RAILS_ENV=production" 
            system "rake db:migrate RAILS_ENV=production" 
            system "rake db:seed RAILS_ENV=production" 

            system "whenever --update-crontab"

            system "bundle exec rake assets:clean RAILS_ENV=production"
            system "bundle exec rake assets:precompile RAILS_ENV=production"
            
            system "sudo chmod 755 public/ -R"

            system "sudo service nginx restart"

            datetime_end = Time.now.strftime('%Y/%m/%d %H:%M:%S')

            file = File.open(Rails.root.join("public", "dev-deploy-log.txt"), "a")
            file.write("completed at: #{ datetime_end }\r\n")
            file.close

        end

    end

end
