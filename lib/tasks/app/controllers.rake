namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do

            L2.msg("Scanning for controllers")

            # get all the engines, controllers and actions
            engines = scan_for_engine_controllers

            # Register descriptors and privileges for all the accounts
            engines.each do |engine, controllers|

                controllers.each do |controller_name, controller_actions|

                    controller = SystemController.find_or_create_by!(name: controller_name)
                    
                    controller_actions.each do |action_name|

                        controller.actions.find_or_create_by!(name: action_name)

                    end
                end
            end
        end

        def scan_for_engine_controllers

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
    end
end
