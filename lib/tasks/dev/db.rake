=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

namespace :dev do

    namespace :db do

        desc "Database hard-reset"
        task reset: :environment do

            #system "rails db:environment:set RAILS_ENV=development"
            system "rake db:drop" 
            system "rake db:create" 
            system "rake db:migrate" 
            system "rake db:seed" 

        end

        desc ""
        task restore: :environment do
            #rake db:drop
            #rake db:create
            #psql -U lesli -d leibrenten_development < leslicloud_production.dump
        end

        desc "Create a backup of database"
        task :backup, [:filename] => [:environment] do |task, args|
            # default postgres configuration
            username = "postgres"
            password = ""
            host = "localhost"
            port = "5432"
            filename = "leslicloud_production.dump"

            unless args[:filename].blank?
                filename = args[:filename] + ".dump"
            end

            database = Rails.application.credentials.db[:database]
            username = Rails.application.credentials.db[:username] unless Rails.application.credentials.db[:username].blank? 
            host = Rails.application.credentials.db[:host] unless Rails.application.credentials.db[:host].blank? 
            port = Rails.application.credentials.db[:port] unless Rails.application.credentials.db[:port].blank? 
            password = "PGPASSWORD=#{Rails.application.credentials.db[:password]}" unless Rails.application.credentials.db[:password].blank?
            
            system "exec #{password} pg_dump -h #{host} -p #{port} -d #{database} -U #{username} > #{Rails.root}/#{filename}"
        end

        desc "Restore database from backup"
        task :restore_backup, [:server_host, :server_username, :key_path, :ruby_version] => [:environment] do |task, args|

            server_host = args[:server_host]
            return if server_host.blank?
            
            ruby_version = RUBY_VERSION
            app_path = "/var/www/lesli"
            server_username = "ubuntu" 
            key_path = "#{ENV["HOME"]}/Desktop/#{server_host}.pem"
            filename="leslicloud_production.dump"

            server_username args[:server_username] unless args[:server_username].blank? 
            key_path = args[:key_path] unless args[:key_path].blank?
            ruby_version = args[:ruby_version] unless args[:ruby_version].blank?

            # default postgres configuration
            username = "postgres"
            host = "localhost"
            port = "5432"
            filename = "leslicloud_production.dump"

            unless args[:filename].blank?
                filename = args[:filename] + ".dump"
            end

            database = Rails.application.credentials.db[:database]
            username = Rails.application.credentials.db[:username] unless Rails.application.credentials.db[:username].blank? 
            host = Rails.application.credentials.db[:host] unless Rails.application.credentials.db[:host].blank? 
            port = Rails.application.credentials.db[:port] unless Rails.application.credentials.db[:port].blank? 

            puts "trying to connect with #{server_host} ... \n"

            system "ssh #{server_username}@#{server_host} -i #{key_path} 'cd #{app_path}; echo RAILS_ENV=production /home/ubuntu/.rvm/gems/#{RUBY_VERSION}/wrappers/rake RAILS_ENV=production rake dev:db:backup[#{filename}]'"

            puts "downloading backup ... \n"
            system "wait && scp -i #{key_path} #{server_username}@#{server_host}:#{app_path}/#{filename} $HOME/Desktop/dl-backups/#{filename}"
            system "ls -l #{ENV["HOME"]}/Desktop/dl-backups/"

            puts "restoring database ... \n"
            system "ps -ef | grep postgres |pgrep #{database} | xargs -I {} sh -c 'sudo kill -9 {}'"

            puts "drop database \n"
            system "rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=development"

            puts "create database ... \n"
            system "rake db:create" 

            system "psql -U #{username} -d #{database} < #{ENV["HOME"]}/Desktop/dl-backups/#{filename}"
            puts "database restored successfully"
        end

    end
end
