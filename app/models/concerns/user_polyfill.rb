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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end


# DEPRECATED METHODS
# We still need to keep the definition of this methods to bring compatibility to old installations of Lesli
module UserPolyfill
    extend ActiveSupport::Concern

    def has_privileges3?(controllers, actions)

        begin

            # This query fetch all the privileges actions that the user have through role descriptor assignments
            sql_role_privile_actions = self.role_privilege_actions
            .select(
                "status",
                "system_controller_actions.name as action",
                "system_controllers.name as controller"
            )
            .joins(system_action: [:system_controller])
            .where("system_controllers.name in (?)", controllers)
            .where("system_controller_actions.name in (?)", actions)
            .to_sql


            # This query fetch all the privileges actions that the user have through privileges actions added to the specific user
            sql_user_privilege_actions = self.user_privilege_actions
            .select(
                "status",
                "system_controller_actions.name as action",
                "system_controllers.name as controller"
            )
            .joins(system_action: [:system_controller])
            .where("system_controllers.name in (?)", controllers)
            .where("system_controller_actions.name in (?)", actions)
            .to_sql


            # This query is on charge of evaluate if the user have every specific privilege action
            # no matter if is given indirectly by role or directly to the user. Then, after getting each
            # specific boolean value of every privilege action, the query evalueate if is there some privilege
            # action on false, if there is a false then the return of the method will be false, but if every
            # privilege action is on true the permission is granted.
            # This is possible by the union of the two previous queries
            granted = ActiveRecord::Base.connection.exec_query("
                select
                    bool_and(grouped_privileges.status) as value
                from (
                    select
                        privilege_actions.controller,
                        privilege_actions.action,
                        BOOL_OR(privilege_actions.status) as status
                    from (
                        #{sql_role_privile_actions}
                        union
                        #{sql_user_privilege_actions}
                    ) AS privilege_actions
                    group by (
                        controller,
                        action
                    )
                ) AS grouped_privileges
            ")
            .first["value"]

            return false if granted.blank?

            return granted

        rescue => exception

            Honeybadger.notify(exception)
            return false

        end

    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    # check role of the user
    def is_role? *roles
        LC::Debug.deprecation("Use has_roles?(role1, role2 ... rolen) instead")
        return has_roles?(roles)
    end

    def log_activity request_method, request_controller, request_action, request_url, description = nil
        LC::Debug.deprecation("Use user.activities, user.logs or log_user_comments instead")
    end

    def generate_password_token
        LC::Debug.deprecation("use generate_reset_password_token instead and build the email manually")
    end

    def self.send_password_reset(user)
        LC::Debug.deprecation("use generate_reset_password_token instead and build the email manually")
    end

    def send_welcome_email
        LC::Debug.deprecation("use generate_reset_password_token instead and build the email manually")
    end
end
