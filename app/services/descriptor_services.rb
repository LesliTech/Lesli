



class DescriptorServices < ApplicationLesliServices

    def find id
        super(self.current_user.account.descriptors.find_by_id(id))
    end

    def index

        descriptors = current_user.account.descriptors
        .select(
            :id,
            :name,
            :category,
            "coalesce(actions.total, 0) as privileges_count",
            Date2.new.date_time.db_timestamps("descriptors")
        )

        # Count the amount of privileges assigned to every descriptor
        descriptors = descriptors.joins(%(
            left join  (
                select
                    count(1) as total,
                    descriptor_id
                from descriptor_privileges
                --where apga.status = TRUE
                group by descriptor_id
            ) as actions
            on actions.descriptor_id = descriptors.id
        ))
        
        # skip native descriptors
        #descriptors = descriptors.where.not("descriptors.name in (?)", ["owner", "sysadmin", "profile"])

        # Filter results by search string
        # unless search_string.blank?
        #     descriptors = descriptors.where("(LOWER(descriptors.name) SIMILAR TO ?)", search_string)
        # end

        descriptors
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

    end 

    def show 
        { 
            :id => resource.id,
            :name => resource.name,
            :category => resource.category,
            :privileges => resource.privileges.joins(system_controller_action: :system_controller).select(
                "descriptor_privileges.id",
                "system_controllers.name as controlle_name",
                "system_controller_actions.name as action_name",
                "descriptor_privileges.created_at"
            )
        }
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
            { controller: "Profiles", actions: ["show"] }, # enable profile view
            #{ controller: "profile/subscriptions", actions: ["options", "index"] }, # enable profile subscriptions
            #{ controller: "user/sessions", actions: ["index"] }, # seession management
            { controller: "Users", actions: ["options", "update"] } # enable user edition
        ].each do |controller_action|

            controller_action[:actions].each do |action_name|

                system_controller_action = SystemController::Action.joins(:system_controller)
                .where("system_controllers.reference = ?", controller_action[:controller])
                .where("system_controller_actions.name = ?", action_name).first

                descriptor.privileges.find_or_create_by(
                    system_controller_action: system_controller_action
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
                system_controller_action: action
            )
        end
    end
end
