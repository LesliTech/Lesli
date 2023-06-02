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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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

    def log_activity_update(current_user, user, old_attributes, new_attributes)
        old_attributes.except!("id", "users_id", "created_at", "updated_at", "deleted_at")
        old_attributes.each do |key, value|
            if value != new_attributes[key]
                value_from = value
                value_to = new_attributes[key]
                value_from = Courier::Core::Date.to_string_datetime(value_from) if value_from.is_a?(Time) || value_from.is_a?(Date)
                value_to = Courier::Core::Date.to_string_datetime(value_to) if value_to.is_a?(Time) || value_to.is_a?(Date)

                user.activities.create!(
                    assigned: current_user,
                    category: "action_update",
                    field_name: key,
                    value_from: value_from,
                    value_to: value_to
                )
            end
        end
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
                assigned: current_user,
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
