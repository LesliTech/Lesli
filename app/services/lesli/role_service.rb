=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class RoleService < Lesli::ApplicationLesliService

        def find id 
            self.resource = current_user.account.roles.find_by_id(id)
            self
        end 

        # Return a list of roles that the user is able to work with
        # according to object level permission
        def list(params)
            current_user.account.roles
            .where("permission_level <= ?", current_user.max_object_level_permission)
            .order(permission_level: :desc, name: :asc)
            .select(:id, :name, :permission_level)
        end


        # @return [Array] Paginated index of users.
        # @description Return a paginated array of users, used mostly in frontend views
        def index 

            current_user.account.roles.where.not(
                :name => ["owner"]
            ).joins("
                left join (
                    select
                        count(1) users,
                        role_id
                    from lesli_user_roles
                    inner join lesli_users as u
                        on u.id = lesli_user_roles.user_id
                        and u.deleted_at is null
                    where lesli_user_roles.deleted_at is null
                    group by (role_id)
                ) users on users.role_id = lesli_roles.id
            ").joins(%(
                left join (
                    select
                        count(1) actions,
                        role_id
                    from lesli_role_actions
                    group by role_id
                ) actions on actions.role_id = lesli_roles.id
            )).where("lesli_roles.permission_level <= ?", current_user.max_object_level_permission)
            .select(
                :id, 
                :name, 
                :active, 
                :isolated, 
                :description,
                :path_default, 
                :object_level_permission, 
                "users.users",
                "actions.actions"
            )
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(object_level_permission: :desc, name: :asc)
        end

        # @overwrite
        # @return {Object}
        # @description Retrives the role
        def show
            self.resource
        end

        # @overwrite
        # @return {Object}
        # @param {params} Hash of the permitted attributes for a role
        # @description Creates a new role
        def create params

            role = current_user.account.roles.new(params)

            unless current_user.can_work_with_role?(role)
                self.error(I18n.t("core.roles.messages_danger_creating_role_object_level_permission_too_high"))
            end

            # check if user can work with that object level permission
            if role.object_level_permission.to_f >= current_user.roles.map(&:object_level_permission).max()
                self.error(I18n.t("core.roles.messages_danger_creating_role_object_level_permission_too_high"))
            end

            # do not create if errors found
            return self unless self.successful?

            # Try to save role and logs if it went OK
            if role.save
                self.resource = role
                #Role::Activity.log_create(current_user, self.resource)
            else
                self.error(role.errors.full_messages.to_sentence)
            end

            self
        end

        # @overwrite
        # @return {Object}
        # @param {params} Hash of the permitted attributes for a role
        # @description Updates role's attributes and saves logs if it went without problem
        def update params
            old_attributes = self.resource.attributes

            unless self.resource.update(params)
                self.error(self.resource.errors.full_messages.to_sentence)
            end

            if self.successful?
                new_attributes = self.resource.attributes

                #LesliSecurity::Role::Activity.log_update(current_user, role, old_attributes, new_attributes)
            end

            self
        end

        # @overwrite
        # @return {Object}
        # @description Deletes the role 
        def destroy
            unless self.resource.destroy
                self.error(self.resource.errors.full_messages.to_sentence)
            end

            if self.successful?
                LesliSecurity::Role::Activity.log_destroy(current_user, self.resource)
            end

            self
        end

        def options 
            { 
                :object_level_permissions => self.roles_with_object_level_permission
            }
        end 

        private 

        def roles_with_object_level_permission
            levels = {}

            # get all the different object level permission registered in the roles
            existing_levels = current_user.account.roles
            .select(:object_level_permission)
            .order(object_level_permission: :desc)
            .distinct
            .map { |level| level.object_level_permission }

            # Build the next available object levels
            # basically we need to add the possibles object level permissions between the
            # existing ones
            existing_levels.each_with_index do |level_current, i|

                level_next = 0

                # get the next OLP in the list of the existing roles
                level_next = existing_levels.to_a[i+1] unless existing_levels.to_a[i+1].nil?

                # calculate the new next level, basically we get the level right in the middle
                # between the existing levels, example:
                #   1000    existing level
                #    750    new projected level
                #    500    existing level
                level_new = (level_current + level_next) / 2

                # add the levels to the levels object
                levels[level_current] = []

                next if level_next == 0

                levels[level_new] = []

            end

            # Get all the existing roles
            current_user.account.roles
            .select(:id, :name, :object_level_permission)
            .where.not(object_level_permission: nil).each do |role|
                levels[role.object_level_permission] = [] if levels[role.object_level_permission].blank?
                # push the role grouping by the object level permission
                levels[role.object_level_permission].push(role)
            end

            levels_sorted = []

            levels.keys.each do |key|
                levels_sorted.push({
                    level: key,
                    roles: levels[key]
                })
            end

            levels_sorted
        end
    end
end
