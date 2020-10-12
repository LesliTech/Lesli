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

        class Routes

            def self.scan

                controller_list=[]

                instance = Rails.configuration.lesli_settings["instance"][:name]
                
                Rails.application.routes.routes.map do |route|
                    route.defaults[:controller]
                end.uniq.each do |controller|
                    next if controller.blank?
                    next if controller.include? "rails"
                    next if controller.include? "action_mailbox"
                    next if controller.include? "active_storage"    

                    # if controller start with the instance code, route belongs to builder engine
                    if controller.start_with?(instance.underscore)
                        controller_list.push({ 
                            module: instance, 
                            platform: "rails_builder",
                            controller: controller.sub(instance.underscore + '/', ''),
                            controller_path: controller
                        })
                        next
                    end

                    # Core routes
                    controller_list.push({ 
                        module: "Core", 
                        platform: "rails_core", 
                        controller: controller,
                        controller_path: controller
                    }) 
                end

                Rails.configuration.lesli_settings["engines"].each do |engine|
                    platform = "rails_engine"
                    platform = "rails_builder" if engine["type"] == "builder"
                    routes = "#{engine["name"]}::Engine".constantize.routes.routes
                    routes.map do |route|
                        route.defaults[:controller]
                    end.uniq.map do |controller|
                        next if controller.blank?
                        controller_list.push({ 
                            module: engine["name"], 
                            platform: platform,
                            controller: controller.sub(engine["code"] + '/', ''),
                            controller_path: controller
                        })
                    end
                end

                return controller_list

            end

        end

    end

end
