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
module Courier

    module Core

        class Users

            def self.list()

                employees = []
                if defined? (CloudLock)
                    return ::User.left_joins(:detail).select(:id, :email, :role, :first_name, :last_name, :created_at).order(:id)
                else
                    return ::User.select(:id, :email, :role, :created_at, :name).order(:id)
                end


                if defined?(CloudTeam)
                    employees = ::CloudTeam::Employee.all
                end

                #users | employees returns a new array with the combination of users and employess

                users

            end

            def self.get(id)
                if defined? (CloudLock)
                    return ::User.lock.joins(:detail).select(:id, :email, :role, :first_name, :last_name, :created_at).find(id)
                else
                    return ::User.select(:id, :email, :role, :name, :created_at).find(id)
                end
            end

        end

    end
    
end
