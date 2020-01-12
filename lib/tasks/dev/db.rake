namespace :dev do

    namespace :db do

        desc "Database hard-reset"
        task reset: :environment do
            
            system "rails db:environment:set RAILS_ENV=development"
            system "rake db:drop RAILS_ENV=development" 
            system "rake db:create RAILS_ENV=development" 
            system "rake db:migrate RAILS_ENV=development" 
            system "rake db:seed RAILS_ENV=development" 

        end

        desc "Database hard-reset"
        task dump_babel: :environment do
            config = with_config
            version = Time.now.strftime('%Y%m%d-%H%M-%S')

            p config[:password]
            command = "PGPASSWORD=#{config[]} pg_dump --verbose --clean --no-owner --no-acl --format=p "
            command = command + "--host #{ActiveRecord::Base.connection_config[:host]} "
            command = command + "--username #{config[:username]} "
            command = command + "#{config[:database]} > " + Rails.root.join("babel-#{version}.sql").to_s

            #exec command

        end

        def with_config
            Rails.application.credentials.db
        end

    end

end
