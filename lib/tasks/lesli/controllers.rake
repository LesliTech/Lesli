namespace :lesli do 
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do

            L2.msg("Registering engines, controllers and actions")

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

        def scan_for_engine_controllers

            # Global container
            controller_list = {
                "core" => {}
            }

            # Get the name of the instance (builder engine)
            instance = "lesli" #Rails.configuration.lesli.dig(:instance, :name)
            
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
            Lesli::System.engines.each do |engine, engine_info|

                # load and retrieve the list of controllers and actions from an engine
                routes = "#{engine}::Engine".constantize.routes.routes.each do |route| 
                    route = route.defaults 

                    # validate if route has information, some special routes like redirects
                    # can generate an empty entry in the route hash
                    next if route.empty?

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
