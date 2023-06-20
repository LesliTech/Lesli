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

class RoleServices < ApplicationLesliServices


    # Return a list of roles that the user is able to work with
    # according to object level permission
    def list
        current_user.account.roles
        .where("object_level_permission <= ?", current_user.max_object_level_permission)
        .order(object_level_permission: :desc, name: :asc)
        .select(:id, :name, :object_level_permission)
    end


    # @return [Array] Paginated index of users.
    # @description Return a paginated array of users, used mostly in frontend views
    def index 

        current_user.account.roles
        .joins("
            left join (
                select
                    count(1) users,
                    role_id
                from user_roles
                inner join  users as u
                    on u.id = user_roles.user_id
                    and u.deleted_at is null
                where user_roles.deleted_at is null
                group by (role_id)
            )
            users on users.role_id = roles.id
        ")
        .where("roles.object_level_permission < ?", current_user.max_object_level_permission)
        .select(
            :id, 
            :name, 
            :active, 
            :isolated, 
            :description,
            :path_default, 
            :object_level_permission, 
            "users.users"
        )
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(object_level_permission: :desc, name: :asc)

    end


    # Creates a query that selects all user information from several tables if CloudLock is present
    def show
        {
            :id => resource.id,
            :name => resource.name,
            :active => resource.active,
            :isolated => resource.isolated,
            :path_default => resource.path_default,
            :path_limited => resource.path_limited,
            :object_level_permission => resource.object_level_permission,
            :created_at => resource.created_at,
            :updated_at => resource.updated_at,
            #:descriptors => resource.descriptors#.joins(:system_descriptor).select(:id, :name, :descriptors_id)
        }
    end


    # @return Array
    # @description Return a list of roles available for the current_user
    def available_roles_for(user)

        roles = current_user.account.roles
        .joins(%(
            left join user_roles
            on user_roles.role_id = roles.id
            and user_roles.deleted_at is null
            and user_roles.user_id = #{ user.id }
        ))
        .where("object_level_permission < ?", current_user.max_object_level_permission)
        .order(object_level_permission: :desc)
        .select(
            "coalesce(roles.id, user_roles.role_id) as id", 
            "name", 
            "object_level_permission",
            "case when user_roles.role_id is null then false else true end as active"
        )

        # only owner can assign any role
        #unless self.has_roles?("owner")
        #    roles = roles.where("object_level_permission < ?", (self.roles.map{ |r| r[:object_level_permission] }).max)
        #end

        roles || []
    end

    def find id
        self.resource = current_user.account.roles.find_by(id: id)
        self
    end
end
