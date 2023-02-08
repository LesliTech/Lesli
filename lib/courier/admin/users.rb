=begin

Copyright (c) 2023, all rights reserved.

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
    module Admin
        class Users

            def self.list(current_user, query, params)
                #return unless defined?(EngineName)
                UserServices.new(current_user).list()
            end

            def self.show current_user, query, params
                #return unless defined?(EngineName)
                user = UserServices.new(current_user).find(params[:id])
                user.show
            end

            def self.index current_user, query, params                
                #return unless defined?(EngineName)
                UserServices.new(current_user).index(query, params)
            end

        end
    end
end
