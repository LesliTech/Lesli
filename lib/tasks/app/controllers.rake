
namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do
            puts  "START SCAN AT: #{Time.now}"

            # get all routes for application controllers
            controllers = LC::System::Controllers.scan

            controllers.each do |controller_name, controller_actions|
                controller = SystemController.find_or_create_by(name: controller_name)

                puts "SETTING UP ACTIONS FOR THE CONTROLLER: #{controller_name}"

                controller_actions.each do |action|
                    system_action = controller.actions.find_or_create_by(name: action)

                    if (system_action.save)
                        Account.all.each do |account|
                            account.role_descriptors.each do |role_descriptor|

                                if ["owner", "sysadmin"].include? role_descriptor
                                    role_descriptor_action = role_descriptor.privilege_actions.find_or_create_by(system_action: system_action)

                                    role_descriptor_action.update(status: true)
                                end

                                # search method that matchs with the role descriptor name
                                method_name = "add_#{role_descriptor.name}_actions"
                                if (RoleDescriptor::DefaultPrivilegeActionsService.method_defined? method_name) # Adding privileges if the method is defined on the class
                                    RoleDescriptor::DefaultPrivilegeActionsService.new.send(method_name, role_descriptor)
                                end
                            end
                        end
                    end
                end
            end

            puts "FINISH SCAN AT: #{Time.now}"
        end
    end
end
