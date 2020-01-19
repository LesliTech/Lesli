namespace :dev do

    namespace :db do

        desc "Database hard-reset"
        task reset: :environment do

            system "rails db:environment:set RAILS_ENV=development"
            system "rake db:drop" 
            system "rake db:create" 
            system "rake db:migrate" 
            system "rake db:seed" 

        end

        desc "Database hard-reset"
        task dump_babel: :environment do
            config = with_config
            version = Time.now.strftime('%Y%m%d-%H%M-%S')

            command = "PGPASSWORD=#{config[:password]} pg_dump --verbose --clean --no-owner --no-acl --format=p "
            command = command + "--host #{ActiveRecord::Base.connection_config[:host]} "
            command = command + "--username #{config[:username]} "
            command = command + "--table cloud_babel_translation_modules "
            command = command + "--table cloud_babel_translation_objects "
            command = command + "--table cloud_babel_translation_strings "
            command = command + "#{config[:database]} > " + Rails.root.join("config", "locales", "babel-#{version}.sql").to_s

            exec command

        end

        def with_config
            Rails.application.credentials.db
        end

    end

end
