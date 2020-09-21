
namespace :app do
    namespace :roles do

        desc "Scan new routes added and create role privileges"
        task build: :environment do

            account = Account.first

            # get all routes for application controllers
            routes = LC::System::Routes.scan

            account.roles.joins(:detail).each do |role|
                routes.each do |route|
                    default_value = false
                    default_value = true if role.detail.name == "owner"
                    default_value = true if role.detail.name == "admin"

                    attributes = {
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

                    role.privileges.create_with(attributes).find_or_create_by(grant_object: route[:controller_path])
                    role.privilege_defaults.create_with(attributes).find_or_create_by(grant_object: route[:controller_path])

                    puts "role privilege created for controller: #{route[:controller_path]}"
                end
            end 

        end
    end
end
