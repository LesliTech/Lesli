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

            def self.scan2
                controller_list = {
                    :core => {}
                }

                instance = Rails.configuration.lesli_settings["instance"][:name]
                
                Rails.application.routes.routes.each do |route| 
                    route = route.defaults 
                    
                    next if route[:controller].blank?
                    next if route[:controller].include? "rails"
                    next if route[:controller].include? "action_mailbox"
                    next if route[:controller].include? "active_storage"
                    
                    controller = route[:controller].to_sym
                    controller_list[:core][controller] = [] unless controller_list[controller]
                    
                    #controller_list[controller].push(route[:action])
                end

                Rails.configuration.lesli_settings["engines"].each do |engine|
                    routes = "#{engine[:name]}::Engine".constantize.routes.routes.each do |route| 
                        route = route.defaults 
                        engine_code = engine[:name].underscore.to_sym
                        controller = route[:controller].to_sym
                        
                        controller_list[engine_code] = {} if controller_list[engine_code].blank?
                        controller_list[engine_code][controller] = [] if controller_list[engine_code][controller].blank?
                        
                        #controller_list[route[:controller]].push(route[:action])

                    end
                end

                return controller_list
            end

            def self.scan
                controller_list = {}

                instance = Rails.configuration.lesli_settings["instance"][:name]
                
                Rails.application.routes.routes.each do |route| 
                    route = route.defaults 
                    
                    next if route[:controller].blank?
                    next if route[:controller].include? "rails"
                    next if route[:controller].include? "action_mailbox"
                    next if route[:controller].include? "active_storage"
                    
                    controller_list[route[:controller]] = [] unless controller_list[route[:controller]]
                    
                    controller_list[route[:controller]].push(route[:action])
                end

                Rails.configuration.lesli_settings["engines"].each do |engine|
                    platform = "rails_engine"
                    platform = "rails_builder" if engine[:type] == "builder"
                    routes = "#{engine[:name]}::Engine".constantize.routes.routes.each do |route| 
                        route = route.defaults 
                        
                        controller_list[route[:controller]] = [] if controller_list[route[:controller]].blank?
                        
                        controller_list[route[:controller]].push(route[:action])

                    end
                end

                return controller_list
            end
        end
    end
end
