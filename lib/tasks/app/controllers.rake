
namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do
            company_name = Rails.application.config.lesli_settings["account"]["company"]["name"]
            
            account = Account.find_by(company_name: company_name)

            system_user = account.users.first

            # get all routes for application controllers
            controllers = LC::System::Controllers.scan

            controllers.each do |controller_name, value|    
                controller = SystemController.find_or_initialize_by(name: controller_name)
                
                if controller.new_record?                             
                    puts "actions: #{value[:actions]} created  for #{controller_name}"
                end
                
                if (controller.save)
                    value[:actions].each do |action|
                        controller.actions.find_or_create_by(name: action)
                    end 
                end
            end
            
            threads = []

            account.roles.where("name = ? or name = ?", "admin", "owner").each do |role|

                threads << Thread.new do 
                    SystemController::Action.all.each do |controller_action|
                        privilege_action = role.privilege_actions.find_or_initialize_by(system_controller_actions_id: controller_action.id)
                        
                        privilege_action.save
                    end
                end
            end
            
            threads.map { |thread| thread.join }

        end
    end
end
