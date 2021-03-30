
namespace :app do
    namespace :roles do

        desc "Scan new routes added and create role privileges"
        task build: :environment do

            account = Account.first

            system_user = account.users.first

            # get all routes for application controllers
            routes = LC::System::Routes.scan

            threads = []

            account.roles.each do |role|

                threads << Thread.new do 

                    routes.each do |route|
                        default_value = false
                        default_value = true if role.name == "owner"
                        default_value = true if role.name == "admin"

                        attributes = {
                                grant_list: default_value,
                                grant_index: default_value, 
                                grant_edit: default_value, 
                                grant_show: default_value, 
                                grant_new: default_value, 
                                grant_create: default_value, 
                                grant_update: default_value, 
                                grant_destroy: default_value, 
                                grant_search: default_value,
                                grant_resources: default_value,
                                grant_options: default_value 
                        }

                        privilege = role.privileges.find_or_initialize_by(grant_object: route[:controller_path])

                        if privilege.new_record?
                            privilege.attributes = attributes

                            if (privilege.save!)
                                new_attributes = privilege.attributes

                                Role.log_activity_create_role_privilege(system_user, role, new_attributes)
                            end
                            puts "role privilege created for controller: #{route[:controller_path]}"
                        end
                    end

                end

            end
            
            threads.map { |thread| thread.join }

        end
    end
end
