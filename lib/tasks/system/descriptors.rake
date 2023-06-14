=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

namespace :system do
    namespace :descriptors do

        # standard methods must have privilege requests only to do actions related
        # for example: my show action should only required privileges to show methods
        # form other controllers.
        #               list, index, show, new, create, edit, update, destroy, search
        denied_privileges_for_index = ['new', 'create', 'edit', 'update', 'destroy']
        denied_privileges_for_show = ['new', 'create', 'edit', 'update', 'destroy']
        denied_privileges_for_new = ['index', 'show', 'edit', 'update', 'destroy']
        denied_privileges_for_edit = ['index', 'show', 'new', 'create', 'destroy']
        denied_privileges_for_destroy = ['index', 'show', 'new', 'create', 'edit', 'update']
        

        desc "Build descriptors and privileges according to the app controllers"
        task build: :environment do

            L2.msg("Registering new Descriptors")

            require_policies()

            # iterate over all the system controllers found installed
            # update this list of controllers after install or uninstall 
            # engines and scaffold resources
            SystemController.all.each do |system_controller| 

                # join the parts of the class name and concat Controller
                policy_name = system_controller.reference + "Policy"

                # finally join the parts of the class name and concat Controller
                controller_name = system_controller.reference + "Controller"

                # Validate that the policy class exists
                # sometimes a bad or wrong route can misspell a controller name
                # this allows to create descriptor only for the existing policies
                next unless Object.const_defined?(policy_name)

                # Create a new instance of the controller class
                policy = Object.const_get(policy_name).new

                # this is the list of standard methods every controller has
                # for custom methods and routes we have to map manually in the policies
                ["list", "index", "show", "create", "edit", "destroy"].each do |descriptor_action|

                    # exit if the policy does not contain specific privileges for the 
                    # standard methods, if the method is not defined in the policy means
                    # privilege for that specific controller/action is not desire
                    next unless policy.respond_to?(descriptor_action.to_sym)
                    
                    # Search for the system_action corresponding to the action policy
                    system_action = system_controller.actions.find_by(:name => descriptor_action)

                    # controller name for humans, ready to be translated by babel
                    descriptor_name = system_controller.name.sub(' ','').underscore.dasherize

                    # Register the new descriptor if it does not exists a descriptor is compounded 
                    # of controller/standard_action and custom privileges, the custom privileges
                    # are needed to make complex views works properly, complex views needs access
                    # to several controllers/actions
                    system_descriptor = SystemDescriptor.create_with({
                        :system_controller => system_controller
                    }).find_or_create_by({ 
                        :name => descriptor_name,
                        :category => descriptor_action
                    }) 

                    # assign all the descriptor to management roles
                    Account.all.each do |account|

                        # assign all the descriptors to the owner and sysadmin roles (default roles)
                        account.roles.find_by(name: 'owner').descriptors.find_or_create_by({
                            system_descriptor: system_descriptor
                        })

                        # sysadmin is an alias of owner, however sysadmin is not owner of the account
                        account.roles.find_by(name: 'sysadmin').descriptors.find_or_create_by({
                            system_descriptor: system_descriptor
                        })

                    end

                    # Register the current controller into the system_descriptor privileges, so the role grants
                    # permissions to render the requested page as html and as json
                    system_descriptor.privileges.find_or_create_by({
                        :system_controller_action => system_action
                    })

                    # register privileges for the descriptor
                    # standar controller/action privileges and specific privileges
                    # required by the policy
                    (policy.send(descriptor_action) || []).each do |privilege|

                        # use the policy information to build the controller and action reference names
                        privilege_controller = privilege.split("#")[0].sub("Controller", "")
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

                        # Search for the system_action corresponding to the action policy
                        system_action = SystemController::Action.joins(:system_controller)
                        .where("system_controllers.reference = ?", privilege_controller)
                        .where("system_controller_actions.name = ?", privilege_action)
                        .first

                        next unless system_action

                        # register the desire privilege for the controller
                        system_descriptor.privileges.find_or_create_by!({
                            :system_controller_action => system_action
                        })

                    end
                end
            end

            # Synchronize privileges cache for all the roles
            PrivilegeServices.new(Role.all).synchronize
        end

        def privilege_error privilege, controller_name
            msg = "Privilege #{privilege} is not allowed for #{controller_name}"
            L2.error(msg)
        end

        # Rake does not support eager_load by default and due we are not including
        # the /lib folder in the autoload_paths, then we have to manually require
        # the policy classes to make it possible to rake to work inside our task.
        # https://guides.rubyonrails.org/v4.2.2/autoloading_and_reloading_constants.html
        # https://dev.to/software_writer/how-to-access-rails-activerecord-models-inside-a-rake-task-5c76
        # http://chrisstump.online/2016/02/12/rails-production-eager-loading/
        def require_policies
            require "#{Rails.root}/lib/policies/application_lesli_policy.rb"
            Dir.glob("#{Rails.root}/lib/policies/**/*.rb").each do |policies| 
                require policies; 
            end
        end

    end
end
