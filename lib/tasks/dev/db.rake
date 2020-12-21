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

    end

end
