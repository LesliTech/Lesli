=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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
    class ResourceService < Lesli::ApplicationLesliService

        DEVISE_CONTROLLERS = [
            "users/registrations",
            "users/sessions",
            "users/passwords",
            "users/confirmations"
        ]

        def initialize 
        end

        def index matrix:false

            # get a matrix of controllers and actions
            c = Resource.actions.joins(:parent).select(
                "parents_lesli_resources.engine as engine",
                "parents_lesli_resources.route as route",
                "parents_lesli_resources.identifier as controller",
                "parents_lesli_resources.label as controller_name",
                "parents_lesli_resources.id as controller_id",
                "lesli_resources.action as action",
                "lesli_resources.id as action_id",
                "case lesli_resources.action
                    when 'index'   then 1
                    when 'show'    then 2
                    when 'new'     then 3
                    when 'edit'    then 4
                    when 'create'  then 5
                    when 'update'  then 6
                    when 'destroy' then 7
                    when 'options' then 8
                    else 9
                end as importance
                "
            )
            .where("parents_lesli_resources.deleted_at is NULL")
            .order("importance DESC")
    
            return c unless matrix
    
            cc = {}
    
            # convert the matrix to a hash of engines with controllers and available actions as values
            # example:
            #   my_engine: { my_controller: [ my list of actions ]}
            c.each do |c|

                engine = c[:engine]
                controller = c[:controller]
    
                # create a uniq container for every action that belongs to a specific controller
                if cc[engine].blank?
                    cc[engine] = {}
                end

                # create a uniq container for every action that belongs to a specific controller
                if cc[engine][controller].blank?
                    cc[engine][controller] = { 
                        id: c[:controller_id], 
                        name: c[:controller_name], 
                        route: c[:route], 
                        actions: []
                    } 
                end

                # push every action to his specic controller
                cc[engine][controller][:actions].push({ 
                    id: c[:action_id], 
                    action: c[:action]
                })
            end
    
            return cc
    
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
                    identifier = controller_route
                    .camelize
                    .gsub('/', '::')

                    name = identifier.demodulize.humanize

                    controller = Lesli::Resource.find_or_initialize_by(route: controller_route)
                    controller.assign_attributes(
                        label: name,
                        engine: engine,
                        identifier: identifier
                    )
                    controller.save!

                    controller_actions.each do |action_name|
                        controller.children.find_or_create_by!(
                            action: action_name,
                            identifier: action_name,
                            label: action_name.humanize
                        )
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
