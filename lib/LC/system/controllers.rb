=begin

Lesli

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

module LC

    module System

        class Controllers

            def self.scan
                controller_list = {}

                instance = Rails.configuration.lesli_settings["instance"][:name]
                
                Rails.application.routes.routes.each do |route| 
                    route = route.defaults 
                    
                    next if route[:controller].blank?
                    next if route[:controller].include? "rails"
                    next if route[:controller].include? "action_mailbox"
                    next if route[:controller].include? "active_storage"
                    
                    controller_list[route[:controller]] = { actions: [] } unless controller_list[route[:controller]]
                    
                    controller_list[route[:controller]][:actions].push(route[:action])
                end

                Rails.configuration.lesli_settings["engines"].each do |engine|
                    platform = "rails_engine"
                    platform = "rails_builder" if engine[:type] == "builder"
                    routes = "#{engine[:name]}::Engine".constantize.routes.routes.each do |route| 
                        route = route.defaults 
                        
                        controller_list[route[:controller]] = { actions: []} if controller_list[route[:controller]].blank?
                        
                        controller_list[route[:controller]][:actions].push(route[:action])

                    end
                end

                return controller_list
            end
        end
    end
end
