namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do

            L2.msg("Scanning for controllers")

            # get all the engines, controllers and actions
            engines = LC::System::Controllers.scan2

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
    end
end
