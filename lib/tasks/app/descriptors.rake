=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

require "#{Rails.root}/lib/LC/system/controllers.rb"

load "#{Rails.root}/lib/policies/application_lesli_policy.rb"

Dir.glob("#{Rails.root}/lib/policies/*.rb").each do |policies| 
    
    return if policies == "application_lesli_policy.rb"; 
    
    load policies;
    
end

namespace :app do
    namespace :descriptors do

        # standard methods must have privilege requests only to do actions related
        # for example: my show action should only required privileges to show methods
        # form other controllers.
        # list, index, show, new, create, edit, update, destroy, search
        denied_privileges_for_index = ['new', 'create', 'edit', 'update', 'destroy']
        denied_privileges_for_show = ['new', 'create', 'edit', 'update', 'destroy']
        denied_privileges_for_new = ['index', 'show', 'edit', 'update', 'destroy']
        denied_privileges_for_edit = ['index', 'show', 'new', 'create', 'destroy']
        denied_privileges_for_destroy = ['index', 'show', 'new', 'create', 'edit', 'update']
        

        desc "Build descriptors and privileges according to the app controllers"
        task build: :environment do

            L2.msg("Registering new Descriptors")

            SystemController.all.each do |controller| 

                # join the parts of the class name and concat Controller
                policy_name = controller.reference + "Policy"

                # finally join the parts of the class name and concat Controller
                controller_name = controller.reference + "Controller"

                # Validate that the class exists
                # sometimes a bad or wrong route can misspell a controller name
                next unless Object.const_defined?(policy_name)

                # Create a new instance of the controller class
                policy = Object.const_get(policy_name).new


                ["index", "show", "create", "edit", "destroy"].each do |descriptor_action|

                    # controller name for humans, ready to be translated by babel
                    descriptor_name = controller.name.sub(' ','').underscore

                    # Register the new descriptor if it does not exists
                    descriptor = SystemDescriptor.create_with({
                        :system_controller => controller
                    }).find_or_create_by({ 
                        :name => descriptor_name,
                        :category => descriptor_action
                    }) 

                    Account.all.each do |account|

                        # We must assign all the descriptors to the owner and sysadmin roles (default roles)
                        account.roles.find_by(name: 'owner').descriptors.find_or_create_by({
                            system_descriptor: descriptor
                        })

                        account.roles.find_by(name: 'sysadmin').descriptors.find_or_create_by({
                            system_descriptor: descriptor
                        })

                    end


                    # Register the current controller into the descriptor privileges, so the role grants
                    # permissions to render the requested page as html and as json
                    descriptor.privileges.find_or_create_by({
                        :controller => controller.route,
                        :action => descriptor_action
                    })

                    # Register the privileges needed by the object and related to the controller
                    # the controller can register requested privileges in two ways:
                    #   - ResourceController#action
                    #   - action (from the same controller)
                    policy.send(descriptor_action).each do |privilege|

                        privilege_controller = privilege.split("#")[0].sub("::", "/").sub("Controller", "").underscore
                        privilege_action = privilege.split("#")[1].downcase

                        # check if my descriptor action is only requiring privileges of the same category
                        case descriptor_action
                        when :index
                            privilege_error(privilege, controller_name) if denied_privileges_for_index.include?(privilege_action)
                        when :show  
                            privilege_error(privilege, controller_name) if denied_privileges_for_show.include?(privilege_action)
                        when :new
                            privilege_error(privilege, controller_name) if denied_privileges_for_new.include?(privilege_action)
                        when :edit
                            privilege_error(privilege, controller_name) if denied_privileges_for_edit.include?(privilege_action)
                        when :destroy
                            privilege_error(privilege, controller_name) if denied_privileges_for_destroy.include?(privilege_action)
                        end

                        # register the desire privilege for the controller
                        descriptor.privileges.find_or_create_by({
                            :controller => privilege_controller,
                            :action => privilege_action
                        })

                    end
                end
            end
        end

        def privilege_error privilege, controller_name
            msg = "Privilege #{privilege} is not allowed for #{controller_name}"
            L2.error(msg)
        end

    end
end
