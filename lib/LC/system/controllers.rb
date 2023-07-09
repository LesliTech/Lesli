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

        class Controllers

            def self.scan2

                # Global container
                controller_list = {
                    "core" => {}
                }

                # Get the name of the instance (builder engine)
                instance = Rails.configuration.lesli.dig(:instance, :name)
                
                # Get the list of controllers and actions of the core
                Rails.application.routes.routes.each do |route| 
                    route = route.defaults 
                    
                    # filter the non-used core routes
                    next if route[:controller].blank?
                    next if route[:controller].include? "rails"
                    next if route[:controller].include? "action_mailbox"
                    next if route[:controller].include? "active_storage"
                    
                    # create a container for the actions related to a controller
                    controller_list["core"][route[:controller]] = [] unless controller_list["core"][route[:controller]]

                    # assign and group all the actions related to the controller
                    controller_list["core"][route[:controller]].push(route[:action])

                end

                # Get the list of controllers and actions from engines
                Rails.configuration.lesli.dig(:engines).each do |engine|

                    # load and retrieve the list of controllers and actions from an engine
                    routes = "#{engine[:name]}::Engine".constantize.routes.routes.each do |route| 
                        route = route.defaults 

                        # validate if route has information, some special routes like redirects
                        # can generate an empty entry in the route hash
                        next if route.empty?

                        # get the engine code
                        engine_code = engine[:name].underscore
                        
                        # create a container for the controllers related to the engine
                        controller_list[engine_code] = {} if controller_list[engine_code].blank?

                        # assign and group all the actions related to the controller
                        controller_list[engine_code][route[:controller]] = [] if controller_list[engine_code][route[:controller]].blank?
                        
                        # assign and group all the actions related to the controller
                        controller_list[engine_code][route[:controller]].push(route[:action])

                    end
                end

                return controller_list
            end

            def self.scan
                controller_list = {}

                instance = Rails.configuration.lesli.dig(:instance, :name)
                
                Rails.application.routes.routes.each do |route| 
                    route = route.defaults 
                    
                    next if route[:controller].blank?
                    next if route[:controller].include? "rails"
                    next if route[:controller].include? "action_mailbox"
                    next if route[:controller].include? "active_storage"
                    
                    controller_list[route[:controller]] = [] unless controller_list[route[:controller]]
                    
                    controller_list[route[:controller]].push(route[:action])
                end

                Rails.configuration.lesli.dig(:engines).each do |engine|
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
