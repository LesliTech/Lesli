
namespace :core do
    namespace :roles do

        desc "Scan new routes added and create role privileges"
        task scan_routes: :environment do
            account = Account.first

            routes = LC::System::Routes.scan
            account.roles.joins(:detail).each do |role|
                routes.each do |route|
                    default_value = false
                    default_value = true if role.detail.name == "owner"
                    default_value = true if role.detail.name == "admin"

                    privilege = role.privileges.find_by(grant_object: route[:controller])
                    privilege_default = role.privilege_defaults.find_by(grant_object: route[:controller]) 

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

                    attributes = attributes.merge({
                        grant_object: route[:controller]
                    })

                    if privilege.blank?
                        role.privileges.create(attributes)
                    end

                    if privilege_default.blank?
                        role.privilege_defaults.create(attributes)
                    end
                end
            end
        end
    end
end