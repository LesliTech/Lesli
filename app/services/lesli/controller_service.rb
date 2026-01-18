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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class ControllerService < Lesli::ApplicationLesliService

        DEVISE_CONTROLLERS = [
            "users/registrations",
            "users/sessions",
            "users/passwords",
            "users/confirmations"
        ]

        def initialize 
        end

        # Scan new routes added and create role privileges
        def build

            # get all the engines, controllers and actions
            engines = scan_for_engine_controllers

            # Register descriptors and privileges for all the accounts
            engines.each do |engine, controllers|

                controllers.each do |controller_route, controller_actions|

                    # Build a strig with the standard name of a Rails controller from the standard routes
                    # Examples: 
                    #   users converts to Users 
                    #   cloud_bell/notifications converts to CloudBell::Notifications
                    # sometimes we need a second split to deal with third level deep of controllers
                    # Example: "Account::Currency::ExchangeRatesController" from "account/currency/exchange_rates"
                    reference = controller_route
                    .split('/')                     # split the controller path by namespace
                    .collect(&:capitalize)          # uppercase the first letter to match the class name convention of Rails
                    .join("::")                     # join by ruby class separator for namespaces
                    .split('_')                     # work with compound words like "exchange_rates"
                    .collect { |x| x[0] = x[0].upcase; x } # convert ['exchange', 'rates'] to ['Exchange', 'Rates']
                    .join('')                       # joins everything in a single string

                    name = reference.sub('::',' ')

                    controller = Lesli::SystemController.create_with({
                        name: name,
                        :engine => engine,
                        :reference => reference
                    }).find_or_create_by!(route: controller_route)
                    
                    controller_actions.each do |action_name|
                        controller.actions.find_or_create_by!(name: action_name) 
                    end
                end
            end
        end

        private 

        def scan_for_engine_controllers

            # Global container
            controller_list = {
                "rails_app" => {},
                "lesli" => {}
            }
            
            # Get the list of controllers and actions of the main rails app
            Rails.application.routes.routes.each do |route| 

                list = "rails_app"
                route = route.defaults
                
                # filter the non-used main app routes
                next if route[:controller].blank?
                next if route[:controller].include? "rails"
                next if route[:controller].include? "action_mailbox"
                next if route[:controller].include? "active_storage"
                next if route[:controller].include? "view_components"
                next if route[:controller].include? "turbo/native/navigation"
                next if route[:controller].include? "lesli/abouts" #default welcome page

                if DEVISE_CONTROLLERS.include?(route[:controller])
                    list = "lesli"
                end
                
                # create a container for the actions related to a controller
                controller_list[list][route[:controller]] = [] unless controller_list[list][route[:controller]]

                # assign and group all the actions related to the controller
                controller_list[list][route[:controller]].push(route[:action])

            end

            # Get the list of controllers and actions from engines
            LesliSystem.engines.each do |engine, engine_info|

                # Do not process main Rails app
                next if engine == "Root"

                # load and retrieve the list of controllers and actions from an engine
                routes = "#{engine}::Engine".constantize.routes.routes.each do |route| 
                    route = route.defaults 

                    # validate if route has information, some special routes like redirects
                    # can generate an empty entry in the route hash
                    next if route.empty?
                    next if route[:controller].include? "rails/health"

                    # get the engine code
                    engine_code = engine_info[:code]
                    
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
    end
end
