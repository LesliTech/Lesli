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

class RoleDescriptor::DefaultPrivilegeActionsService

    # @description This class is use to fetch the default privileges o a specific role descriptor
    # the privilege  actions are fetched using the same name of the role descriptor and adding the suffix _actions
    # Example
    # actions = RoleDescriptor::DefaultPrivilegeActionsService["#{role_descriptor_name}_actions"]
    def initialize
    end

    # @return Array[Hash<category[String], actions[SystemController::Action]>]
    # @description Return the list of privilege actions defined for
    # profile descriptor
    # Example
    # actions = RoleDescriptor::DefaultPrivilegeActionsService.profile_actions
    def profile_actions
        actions = []

        # finding the actions needeed on the controllers
        [
            {controller: "profiles", actions: ["show"] }, # enable profile view
            {controller: "profile/subscriptions", actions: ["options"] }, # enable profile subscriptions
            {controller: "users",    actions: ["options", "update"] }, # enable user edition
            {controller: "user/sessions", actions: ["index"] } # seession management
        ].each do |privilege|
            privilege[:actions].each do |action|

                system_action = SystemController::Action.joins(:system_controller)
                .where("system_controllers.name = ?", privilege[:controller])
                .where("system_controller_actions.name = ?", action)
                .first

                actions.push(system_action) if system_action
            end
        end

        return [
            category: "show",
            actions: actions
        ]
    end
end