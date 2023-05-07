



class SystemDescriptorService < ApplicationLesliServices

    def index

        descriptors = current_user.account.descriptors.select(
            :id,
            :name,
            :description,
            "coalesce(actions.total, 0) as privileges_count",
            Date2.new.date_time.db_timestamps("descriptors")
        )

        # Count the amount of privileges assigned to every descriptor
        descriptors = descriptors.joins("
            left join  (
                select
                    count(1) as total,
                    descriptors_id
                from descriptor_privileges
                --where apga.status = TRUE
                group by descriptors_id
            ) as actions
                on actions.descriptors_id = descriptors.id
        ")
        
        # skip native descriptors
        #descriptors = descriptors.where.not("descriptors.name in (?)", ["owner", "sysadmin", "profile"])

        # Filter results by search string
        unless search_string.blank?
            descriptors = descriptors.where("(LOWER(descriptors.name) SIMILAR TO ?)", search_string)
        end

        descriptors
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

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
            { controller: "profiles", actions: ["show"] }, # enable profile view
            { controller: "users", actions: ["options"] },
            { controller: "profile/subscriptions", actions: ["options", "index"] }, # enable profile subscriptions
            { controller: "user/sessions", actions: ["index"] }, # seession management
            { controller: "users", actions: ["options", "update"] } # enable user edition
        ].each do |controller_action|

            controller_action[:actions].each do |action_name|

                system_controller_action = SystemController::Action.joins(:system_controller)
                .where("system_controllers.name = ?", controller_action[:controller])
                .where("system_controller_actions.name = ?", action_name).first

                descriptor.privileges.find_or_create_by(
                    action: system_controller_action
                )
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
        actions = SystemController::Action.all

        actions.each do |action|
            descriptor.privileges.find_or_create_by(
                action: action
            )
        end
    end
end
