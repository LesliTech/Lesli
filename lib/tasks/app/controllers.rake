
namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do
            puts  "START SCAN AT: #{Time.now}"
            
            # get all routes for application controllers
            controllers = LC::System::Controllers.scan

            threads = []

            controllers.each do |controller_name, controller_actions|
                controller = SystemController.find_or_create_by(name: controller_name)

                puts "SETTING UP ACTIONS FOR THE CONTROLLER: #{controller_name}"
                
                controller_actions.each do |action|
                    threads << Thread.new do 
                        system_action = controller.actions.find_or_create_by(name: action)
                        
                        if (system_action.save)   
                            Account.all.each do |account|                      
                                account.role_descriptors.where("name in (?)", ["owner", "sysadmin"]).each do |descriptor|
                                    role_descriptor_action = descriptor.privilege_actions.find_or_create_by(system_action: system_action)
                                    
                                    role_descriptor_action.update(status: true)
                                end
                            end
                        end
                    end
                end
                
                threads.map(&:join)
            end    
                    
            puts "FINISH SCAN AT: #{Time.now}"
            
            add_default_privilege_actions() # add actions of defaults role descriptors
        end
        
        def add_default_privilege_actions()
            actions = RoleDescriptor::DefaultPrivilegeActionsService.new.profile_actions
            
            Account.all.each do |account|  
                add_profile_privileges(account, actions)
            end
        end
        
        def add_profile_privileges(account, actions)
            puts "ADDING DEFAULT PRIVILEGE ACTIONS FOR PROFILE DESCRIPTOR"
            
            profile_descriptor = account.role_descriptors.find_or_create_by(name: "profile")
            
            if (profile_descriptor) 
                actions.each do |system_action|
                    profile_descriptor.privilege_actions.find_or_create_by(
                        category: RoleDescriptor::PrivilegeAction.categories["update"], 
                        system_action: system_action
                    ).update(status: TRUE)
                end
            end 
        end
    end
end
