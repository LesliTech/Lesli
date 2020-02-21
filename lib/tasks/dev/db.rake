=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

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

        desc "Backup babel"
        task babel_backup: :environment do
            config = with_config
            version = Time.now.strftime('%Y%m%d-%H%M-%S')
            version = Time.now.strftime('%Y%m%d')

            command = "PGPASSWORD=#{config[:password]} pg_dump --verbose --clean --no-owner --no-acl --format=p "
            command = command + "--host #{ActiveRecord::Base.connection_config[:host]} "
            command = command + "--username #{config[:username]} "
            command = command + "--table cloud_babel_translation_modules "
            command = command + "--table cloud_babel_translation_objects "
            command = command + "--table cloud_babel_translation_strings "
            command = command + "#{config[:database]} > " + Rails.root.join("db", "backup", "babel-#{version}.sql").to_s

            system command

        end

        def with_config
            Rails.application.credentials.db
        end

    end

end
