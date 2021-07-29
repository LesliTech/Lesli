
namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do
            puts  "START SCAN AT: #{Time.now}"
            
            # get all routes for application controllers
            controllers = LC::System::Controllers.scan

            threads = []

            controllers.each do |controller_name, value|
                controller = SystemController.find_or_initialize_by(name: controller_name)

                puts "setting up actions for the controller: #{controller_name}"
                
                if (controller.save)
                    value[:actions].each do |action|
                        system_action = controller.actions.find_or_initialize_by(name: action)
                        
                        if (system_action.save)   
                            Account.all.each do |account|                      
                                account.role_descriptors.where("name in (?)", ["owner", "admin"]).each do |descriptor|
                                    role_descriptor_action = descriptor.privilege_actions.new(system_action: system_action, status: true)

                                    role_descriptor_action.save!
                                end
                            end
                        end
                    end
                end
            end    
                    
            puts  "FINISH SCAN AT: #{Time.now}"
            
            add_default_privilege_actions() # add actions of defaults role descriptors
        end
        
        def add_default_privilege_actions()
            Account.all.each do |account|  
                add_profile_privileges(account)
            end
        end
        
        def add_profile_privileges(account)
            puts "ADDING DEFAULT PRIVILEGE ACTIONS FOR PROFILE DESCRIPTOR"
            
            profile_descriptor = account.role_descriptors.find_or_create_by(name: "profile")
            
            if (profile_descriptor) 

                [   
                    {controller: "profiles", actions: ["show"] },
                    {controller: "users",    actions: ["options", "update"] },
                    {controller: "user/sessions", actions: ["index"] }
                ].each do |privilege|
                    privilege[:actions].each do |action|
                    
                        system_action = SystemController::Action.joins(:system_controller)
                        .where("system_controllers.name = ?", privilege[:controller])
                        .where("system_controller_actions.name = ?", action)
                        .first
                        
                        profile_descriptor.privilege_actions.find_or_create_by(
                            category: RoleDescriptor::PrivilegeAction.categories["update"], 
                            system_action: system_action
                        ).update(status: TRUE) if system_action
                    end
                end 
            end 
        end
    end
end
