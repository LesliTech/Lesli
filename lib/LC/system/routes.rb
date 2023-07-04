=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module LC

    module System

        class Routes

            def self.scan

                #CloudBabel::Engine.routes.routes.map { |route| route.defaults[:controller] }.uniq

                controller_list=[]

                instance = Rails.configuration.lesli.dig(:instance, :name)
                
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

                Rails.configuration.lesli.dig(:engines).each do |engine|
                    platform = "rails_engine"
                    platform = "rails_builder" if engine[:type] == "builder"
                    routes = "#{engine[:name]}::Engine".constantize.routes.routes
                    routes.map do |route|
                        route.defaults[:controller]
                    end.uniq.map do |controller|
                        next if controller.blank?
                        controller_list.push({ 
                            module: engine[:name], 
                            platform: platform,
                            controller: controller.sub(engine[:code] + '/', ''),
                            controller_path: controller
                        })
                    end
                end

                return controller_list

            end

        end

    end

end
