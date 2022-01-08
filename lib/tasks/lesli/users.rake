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


#
require "./lib/tasks/lesli_rake"


#
class LesliUsersRake < LesliRake

    def initialize
        namespace :lesli do

            namespace :users do 

                desc "List all the users"
                task :list => :environment do |task, args|
                    
                    # execute requested action
                    self.list

                end

            end 

        end

    end

    private 

    def list
        users = ::User
        .joins("inner join user_details ud on ud.users_id = users.id")
        .select(
            :id, :active, :email, :current_sign_in_at, 
            "CONCAT(ud.first_name, ' ',ud.last_name) as name"
        ).order(:id)

        LC::Debug.table users

    end

end


#
LesliUsersRake.new
