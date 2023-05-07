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

Dir.glob("#{Rails.root}/lib/policies/*.rb").each { |policies| load policies }

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

            # get all the engines, controllers and actions
            engines = LC::System::Controllers.scan2

            engines.each do |engine, controllers|

                controllers.each do |controller, actions|

                    # Build a strig with the standard name of a Rails controller,
                    #   Example: "UsersControllers, CloudBell::NotificationsController"
                    # sometimes we need a second split to deal with third level deep of controllers
                    #   Example: "Account::Currency::ExchangeRatesController" from "account/currency/exchange_rates"
                    objeto = controller.split('/')      # split the controller path by namespace
                    .collect(&:capitalize)          # uppercase the first letter to match the class name convention of Rails
                    .join("::")                     # join by ruby class separator for namespaces
                    .split('_')                     # work with compound words like "exchange_rates"
                    .collect { |x| x[0] = x[0].upcase; x } # convert ['exchange', 'rates'] to ['Exchange', 'Rates']

                    policy_name = objeto.join('').concat("Policy")  # finally join the parts of the class name and concat Controller
                    controller_name = objeto.join('').concat("Controller")  # finally join the parts of the class name and concat Controller

                    # Validate that the class exists
                    # sometimes a bad or wrong route can misspell a controller name
                    next unless Object.const_defined?(policy_name)

                    # Create a new instance of the controller class
                    policy = Object.const_get(policy_name).new


                    ["index", "show", "create", "edit", "destroy"].each do |descriptor_action|

                        # controller name for humans, ready to be translated by babel
                        controller_babel = "#{controller_name.sub('Controller','').sub('::','')}#{descriptor_action.capitalize}".underscore.sub('/','_')

                        # controller path like the route paths build by rails
                        controller_path = controller_name.sub("::", "/").sub("Controller", "").underscore

                        # Register the new descriptor if it does not exists
                        descriptor = SystemDescriptor.create_with({
                            :name => controller_path,
                            :reference => controller
                        }).find_or_create_by({ 
                            :controller => controller,
                            :action => descriptor_action,
                            :engine => engine
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
                            :controller => controller_path,
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

        end

        def privilege_error privilege, controller_name
            msg = "Privilege #{privilege} is not allowed for #{controller_name}"
            L2.error(msg)
        end

    end
end
