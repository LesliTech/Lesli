=begin

Copyright (c) 2021, all rights reserved.

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

class DescriptorService

    @descriptor = nil

    # @description This class is use to add the default actions to a descriptor
    # the privilege  actions are fetched using the same name of the role descriptor and adding the suffix _actions
    # Example
    # actions = RoleDescriptor::DefaultPrivilegeActionsService["#{role_descriptor_name}_actions"]
    def initialize descriptor
        @descriptor = descriptor
    end

    # @return [void]
    # @param role_descriptor [RoleDescriptor] The role_descriptor on wich we want to add the system actions
    # @description Return the list of privilege actions defined for
    # profile descriptor
    # Example
    # RoleDescriptor::DefaultPrivilegeActionsService.add_profile_actions(RoleDescriptor.last)
    def self.add_profile_privileges(descriptor)

        # Adding default system actions for profile descriptor
        [
            {
                category: "show",
                contollers: [
                    {name: "profiles", actions: ["show"] }, # enable profile view
                    {name: "users", actions: ["options"] },
                    {name: "profile/subscriptions", actions: ["options", "index"] }, # enable profile subscriptions
                    {name: "user/sessions", actions: ["index"] } # seession management
                ]
            },
            {
                category: "update",
                contollers: [
                    { name: "users", actions: ["options", "update"] }, # enable user edition
                ]
            }
        ].each do |data|
            data[:contollers].each do |controller|
                controller[:actions].each do |action_name|

                    system_controller_action = SystemController.joins(:actions)
                    .where("system_controllers.name = ?", controller[:name])
                    .where("system_controller_actions.name = ?", action_name)
                    .select(
                        "system_controllers.name as controller_name",
                        "system_controller_actions.name as controller_action"
                    ).first

                    descriptor.privileges.find_or_create_by(
                        controller: system_controller_action[:controller_name],
                        action: system_controller_action[:controller_action]
                    )
                end
            end
        end
    end

    # @return [void]
    # @param role_descriptor [RoleDescriptor] The role_descriptor on wich we want to add the system actions
    # @description Return the list of privilege actions defined for
    # profile descriptor
    # Example
    # RoleDescriptor::DefaultPrivilegeActionsService.add_profile_actions(RoleDescriptor.last)
    def self.add_owner_privileges(descriptor)

        # Adding default system actions for profile descriptor
        controllers = SystemController.index nil, nil

        controllers.each do |controller|

            controller[:actions].each do |action|

                descriptor.privileges.find_or_create_by!(
                    controller: controller[:name],
                    action: action[:action]
                )

            end
        end
    end
end
