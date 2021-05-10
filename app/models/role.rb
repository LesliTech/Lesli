=begin

Copyright (c) 2020, all rights reserved.

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

class Role < ApplicationLesliRecord

    belongs_to :account,            foreign_key: "accounts_id"

    has_many :privileges,           foreign_key: "roles_id",    class_name: "Role::Privilege",          dependent: :delete_all
    has_many :activities,           foreign_key: "roles_id"

    def self.list current_user, query
        current_user.account.roles
        .order(object_level_permission: :desc, name: :asc)
        .where("object_level_permission <= ?", current_user.roles.map(&:object_level_permission).max())
        .select(:id, :name, :object_level_permission)
        .order(object_level_permission: :desc)
    end

    def self.index(current_user, query)
        roles = current_user.account.roles
        .joins("
            left join (
                select
                    count(1) user_count,
                    roles_id
                from user_roles
                inner join  users as u
                    on u.id = user_roles.users_id
                    and u.deleted_at is null
                where user_roles.deleted_at is null
                group by (roles_id)
            )
            users on users.roles_id = roles.id
        ")
        .order(object_level_permission: :desc, name: :asc)
        .select(:id, :name, :active, :only_my_data, :default_path, :object_level_permission, "users.user_count")

        unless query[:filters].blank?
            roles = roles.where("lower(roles.name) like ?", "%#{query[:filters][:text].downcase}%") unless query[:filters][:text].blank?
            roles = roles.where("roles.object_level_permission < ?", query[:filters][:object_level_permission]) unless query[:filters][:object_level_permission].blank?
        end

        roles = roles
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(object_level_permission: :desc, name: :asc)

        LC::Response.pagination(
            roles.current_page,
            roles.total_pages,
            roles.total_count,
            roles.length,
            roles
        )

    end

    def show()
        Role.where("roles.id = ?", id)
        .select(:id, :name, :active, :object_level_permission, :only_my_data, :default_path)
        .first
    end

    # @return [void]
    # @description Creates all privileges for this role in default false value. The task app:routes:build cannot be used
    #   because it is a rake task, and because it scans routes for all roles, and it would be very inefficient
    # @example
    #   role = Role.new(detail_attributes: {name: "test_role", object_level_permission: 10})
    #   # This method will be called automatically within an after_create callback
    #   puts role.privileges.to_json # Should display all privileges that existed at the moment of the role's creation
    def initialize_role_privileges

        # get all routes for application controllers
        routes = LC::System::Routes.scan

        routes.each do |route|

            privilege = self.privileges.find_or_create_by(grant_object: route[:controller_path])

            if self.name === "owner" || self.name === "admin"
                grant_access = true
                privilege.update(
                    grant_index: grant_access,
                    grant_list: grant_access,
                    grant_create: grant_access,
                    grant_new: grant_access,
                    grant_edit: grant_access,
                    grant_show: grant_access,
                    grant_update: grant_access,
                    grant_destroy: grant_access,
                    grant_options: grant_access,
                    grant_resources: grant_access,
                    grant_search: grant_access,
                    grant_actions: grant_access
                )
            end

            puts "role: #{self.name} privilege created for controller: #{route[:controller_path]}"

        end

        # enable profile privileges
        self.privileges.find_by(grant_object: "profiles").update(grant_show: true)
        self.privileges.find_by(grant_object: "users").update(grant_options: true, grant_update: true)

    end

    # @return [Boolean]
    # @description Returns if a role it is assigned to users.
    def has_users?
        User::Role.where(role: self).count > 0
    end

    #######################################################################################
    ##############################  Activities Log Methods   ##############################
    #######################################################################################

    # @return [void]
    # @param current_user [::User] The user that created the role
    # @param [Role] The role that was created
    # @description Creates an activity for this role indicating who created it. And
    #   also creates an activity with the initial status of the role
    # Example
    #   params = {...}
    #   role = Role.create(params)
    #   Role.log_activity_create(User.find(1), role)
    def self.log_activity_create(current_user, role)
        role.activities.create(
            user_creator: current_user,
            category: "action_create"
        )
    end

    # @return [void]
    # @param current_user [::User] The user that created the role
    # @param role [Role] The role that was created
    # @param old_attributes[Hash] The data of the record before update
    # @param new_attributes[Hash] The data of the record after update
    # @description Creates an activity for this role if someone changed any of this values
    # Example
    #   role = Role.find(1)
    #   old_attributes  = role.attributes.merge({detail_attributes: role.detail.attributes})
    #   role.update(main_employee: User.find(33))
    #   new_attributes = role.attributes.merge({detail_attributes: role.detail.attributes})
    #   Role.log_activity_update(User.find(1), role, old_attributes, new_attributes)
    def self.log_activity_update(current_user, role, old_attributes, new_attributes)
        old_attributes.except!("id", "accounts_id", "created_at", "updated_at", "deleted_at")
        old_attributes.each do |key, value|
            if value != new_attributes[key]
                value_from = value
                value_to = new_attributes[key]
                value_from = Courier::Core::Date.to_string_datetime(value_from) if value_from.is_a?(Time) || value_from.is_a?(Date)
                value_to = Courier::Core::Date.to_string_datetime(value_to) if value_to.is_a?(Time) || value_to.is_a?(Date)

                role.activities.create(
                    user_creator: current_user,
                    category: "action_update",
                    field_name: key,
                    value_from: value_from,
                    value_to: value_to
                )
            end
        end
    end

    # @return [void]
    # @param current_user [::User] The user that deleted the role
    # @param [Role] The role that was deleted
    # @description Creates an activity for this role indicating that someone deleted it
    # Example
    #   role = Role.find(1)
    #   Role.log_activity_destroy(User.find(1), role)
    def self.log_activity_destroy(current_user, role)
        role.activities.create(
            user_creator: current_user,
            category: "action_destroy"
        )
    end

    # @return [void]
    # @param current_user [::User] The user that created the role
    # @param role [Role] The role
    # @param attributes [Role::Privilege.attributes] The attributes of the role privilege created
    # @description Adds an activity if a new privilege is added to the role
    # Example
    #   params = {...}
    #   role = Role.find(1)
    #   privilege = role.privileges.create(params)
    #   Role.log_activity_create_privilege(
    #        User.find(1),
    #        role,
    #        privilege
    #    )
    def self.log_activity_create_role_privilege(current_user, role, attributes)
        controller_name = attributes["grant_object"]

        attributes.except!("id", "roles_id", "grant_object", "created_at", "updated_at", "deleted_at")
        attributes.each do |key, value|
            value_to = attributes[key]
            value_to = Courier::Core::Date.to_string_datetime(value_to) if value_to.is_a?(Time) || value_to.is_a?(Date)

            role.activities.create(
                user_creator: current_user,
                category: "action_create_role_privilege",
                field_name: key,
                value_to: value_to,
                description: controller_name
            )
        end
    end

    # @return [void]
    # @param current_user [::User] The user that created the role
    # @param role [Role] The role
    # @param old_attributes [Role::Privilege.attributes] The old attributes of the role privilege updated
    # @param new_attributes [Role::Privilege.attributes] The new attributes of the role privilege updated
    # @description Adds an activity if a privilege is updated
    # Example
    #   params = {...}
    #   role = Role.find(1)
    #   privilege = role.privileges.create(params)
    #   Role.log_activity_update_privilege(
    #        User.find(1),
    #        role,
    #        privilege
    #    )
    def self.log_activity_update_role_privilege(current_user, role, old_attributes, new_attributes)
        controller_name = old_attributes["grant_object"]

        old_attributes.except!("id", "roles_id", "grant_object", "created_at", "updated_at", "deleted_at")
        old_attributes.each do |key, value|
            if value != new_attributes[key]
                value_from = value
                value_to = new_attributes[key]
                value_from = Courier::Core::Date.to_string_datetime(value_from) if value_from.is_a?(Time) || value_from.is_a?(Date)
                value_to = Courier::Core::Date.to_string_datetime(value_to) if value_to.is_a?(Time) || value_to.is_a?(Date)

                role.activities.create(
                    user_creator: current_user,
                    category: "action_update_role_privilege",
                    field_name: key,
                    value_from: value_from,
                    value_to: value_to,
                    description: controller_name
                )
            end
        end
    end
end
