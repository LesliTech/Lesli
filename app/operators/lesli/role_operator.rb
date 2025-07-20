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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class RoleOperator < Lesli::ApplicationLesliService

        @role = nil
        @action = nil

        def initialize role, action=nil
            @role = role
            @action = action
        end

        def add_profile_actions

            # Adding default system actions for profile descriptor
            [
                { controller: "lesli_admin/profiles", actions: ["show"] },      # enable profile view
                { controller: "lesli/users", actions: ["options", "update"] },  # enable user edition
                { controller: "lesli/abouts", actions: ["show"] },              # system status
                { controller: "lesli/user/sessions", actions: ["index"] }       # session management
            ].each do |controller_action|

                controller_action[:actions].each do |action_name|

                    system_controller_action = SystemController::Action.joins(:system_controller)
                    .where("lesli_system_controllers.route = ?", controller_action[:controller])
                    .where("lesli_system_controller_actions.name = ?", action_name)

                    @role.actions.find_or_create_by(
                        action: system_controller_action.first
                    )
                end
            end
        end

        def add_owner_actions

            # Adding default system actions for profile descriptor
            actions = SystemController::Action.all 

            actions.each do |action|
                @role.actions.find_or_create_by(action: action)
            end
        end

        # Syncronize the descriptor privileges with the role privilege cache table 
        def synchronize 

            # bulk all the descriptor privileges
            # this script was built manually for performance, maintenance
            # and to make it easy to read for future changes, basically what it does 
            # is get the controllers and actions assigned to a descriptor through the 
            # system_descriptor_privileges table and create an array of hashes with
            # all the raw privileges (this includes duplicated privileges)
            # IMPORTANT: A descriptor privilege is evaluated as active if:
            #   - the role has assigned the descriptor through the power association
            #   - the descriptor has assigned the privilege through the controller actions table
            #   - the power has active that group of actions, this means that, if the power has
            #     not marked as active the pshow, pindex, etc column the power is not active
            #     even if it is assigned and active to a descriptor
            records = Lesli::Role.joins(%(
                INNER JOIN "lesli_role_actions" 
                ON "lesli_role_actions"."role_id" = "lesli_roles"."id"
            )).joins(%(
                INNER JOIN lesli_system_controller_actions 
                ON lesli_system_controller_actions.id = lesli_role_actions.action_id
            )).joins(%(
                INNER JOIN lesli_system_controllers 
                ON lesli_system_controllers.id = lesli_system_controller_actions.system_controller_id
            )).select(%(
                lesli_role_actions.role_id as role_id,
                lesli_system_controllers.route as controller, 
                lesli_system_controller_actions.name as action,
                lesli_role_actions.deleted_at IS NULL as active
            )).with_deleted


            # get privileges only for the given role, this is needed to sync only modified roles
            records = records.where("lesli_role_actions.role_id" => @role.id)

            # get privileges only for the given role action, this is needed to sync only modified actions
            records = records.where("lesli_role_actions.id" => @action.id) if @action


            # we use the deleted_at column to know if a privilege is enable or disable, NULL values
            # at the deleted_at column means privilege is active, so if we sort by deleted_at column
            # all the active privileges will be at the top, then the uniq method is going to take
            # always the active values, to completely disable a privilege for a specific controller/action
            # we have to disable in all the roles
            records = records.order("lesli_role_actions.deleted_at DESC")


            # convert the results to json so it is easy to insert/update
            records = records.as_json(only: [:controller, :action, :role_id, :active])

            
            # IMPORTANT: We must save only uniq privileges in the role_privilege table
            # this means that it does not matters how many times we defined a privilege dependency
            # we insert the privilege only once.
            # Example: If we defined that we need access to UsersController#index in 20 descriptors,
            # in the role_privileges will be only one record for that specific controller and action
            records = records.uniq do |privilege|

                # NOTE: If can disable a privilege that belongs to a descriptor, 
                # however, if the same privilege is define in another active descriptor, 
                # the role that has both descriptor will be able to access the resources 
                # of that privilege, that is a normal and desire behavior.
                [privilege["controller"], privilege["action"], privilege["role_id"]]
            end


            # small check to ensure I have records to update/insert
            return if records.blank?

            # bulk update/insert into role privilege cache table
            # IMPORTANT: Due to the importance and how delicate this process is, it is better
            #            to copy the controller name and actions from the system, instead of 
            #            just have a reference to the system_controller_actions table
            Lesli::Role::Privilege.with_deleted.upsert_all(records, unique_by: [:controller, :action, :role_id])
        end 
    end
end
