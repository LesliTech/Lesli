=begin

Copyright (c) 2021, all rights reserved.

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

namespace :lesli do
    namespace :users do 
        desc "List of active users"
        task :list => :environment do |task, args|

            users = ::User
            .joins(:detail)
            .select(
                :id, :email, 
                "CONCAT(user_details.first_name, ' ',user_details.last_name) as name",
                :active,
                LC::Date2.new.db_column("created_at", "users")
            ).order(:id)
        
            L2.table users

        end
    end 
end
