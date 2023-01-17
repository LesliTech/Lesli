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


# DEPRECATED METHODS
# We still need to keep the definition of this methods to bring compatibility to old installations of Lesli
module UserPolyfill
    extend ActiveSupport::Concern


    # @return [void]
    # @description Delete all the active sessions for a given user
    # TODO:
    #   add support to delete sessions for specific devices
    #   add support to delete all sesssions
    # DEPRECATED
    def close_session

        # get last session of the user
        session = self.sessions.last

        # add delete date to the last active session if active session exists
        session.destroy if not session.blank?

    end


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
