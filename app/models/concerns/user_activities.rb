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


# User Activities methods
# Methods related to cloudobject/activities and user_logs
module UserActivities
    extend ActiveSupport::Concern


    # @return [void]
    # @description Register a new log for the current user
    # @param description String Details about the process
    # @param session String Current or active session id
    def log description, session=nil
        self.logs.create(session, description)
    end


    # Define class methods from given block
    # This allows to inject class methods to the User model, so we can use:
    # User.log_activity_create
    class_methods do 


        # @return [void]
        # @param current_user [::User] The user that created the user
        # @param [User] The user that was created
        # @description Creates an activity for this user indicating who created it.
        # Example
        #   params = {...}
        #   user = User.create(params)
        #   User.log_activity_create(User.find(1), user)
        def log_activity_create(current_user, user)
            user.activities.create(
                owner: current_user,
                category: "action_create"
            )
        end


        # @return [void]
        # @param current_user [::User] The user that created the user
        # @param user [User] The User that was created
        # @param old_attributes[Hash] The data of the record before update
        # @param new_attributes[Hash] The data of the record after update
        # @description Creates an activity for this user if someone changed any of this values
        # Example
        #   user = User.find(1)
        #   old_attributes  = user.attributes.merge({detail_attributes: user.detail.attributes})
        #   user.update(main_employee: User.find(33))
        #   new_attributes = user.attributes.merge({detail_attributes: user.detail.attributes})
        #   User.log_activity_update(User.find(1), user, old_attributes, new_attributes)
        def log_activity_update(current_user, user, old_attributes, new_attributes)
            old_attributes.except!("id", "users_id", "created_at", "updated_at", "deleted_at")
            old_attributes.each do |key, value|
                if value != new_attributes[key]
                    value_from = value
                    value_to = new_attributes[key]
                    value_from = Courier::Core::Date.to_string_datetime(value_from) if value_from.is_a?(Time) || value_from.is_a?(Date)
                    value_to = Courier::Core::Date.to_string_datetime(value_to) if value_to.is_a?(Time) || value_to.is_a?(Date)

                    user.activities.create(
                        owner: current_user,
                        category: "action_update",
                        field_name: key,
                        value_from: value_from,
                        value_to: value_to
                    )
                end
            end
        end


        # @return [void]
        # @param current_user [::User] The user that created the user
        # @param user [User] The User that was created
        # @param user [Role] The Role assigned to the user
        # @description Creates an activity for this user if someone adds a new role
        # Example
        #   user = User.find(1)
        #   role = User.find(1)
        #   User.log_activity_create_user_role(current_user, user, role)
        def log_activity_create_user_role(current_user, user, role)
            role_name = role.name

            user.activities.create(
                owner: current_user,
                category: "action_create_user_role",
                value_to: role_name
            )
        end

        
        # @return [void]
        # @param current_user [::User] The user that created the user
        # @param user [User] The User that was created
        # @param user [Role] The Role assigned to the user
        # @description Creates an activity for this user if someone removes a role
        # Example
        #   user = User.find(1)
        #   role = User.find(1)
        #   User.log_activity_destroy_user_role(current_user, user, role)
        def log_activity_destroy_user_role(current_user, user, role)
            role_name = role.name

            user.activities.create(
                owner: current_user,
                category: "action_destroy_user_role",
                value_to: role_name
            )
        end
    end
end
