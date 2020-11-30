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

class Role < ApplicationRecord
    
    belongs_to :account, foreign_key: "accounts_id"
    #has_many :users, foreign_key: "roles_id"
    #has_many :user_roles, foreign_key: "roles_id"
    has_many :privileges, class_name: "Role::Privilege", foreign_key: "roles_id", dependent: :delete_all
    has_many :privilege_defaults, class_name: "Role::PrivilegeDefault", foreign_key: "roles_id", dependent: :delete_all

    has_one :detail, inverse_of: :role, autosave: true, foreign_key: "roles_id", dependent: :destroy 
    accepts_nested_attributes_for :detail, update_only: true

    def destroy(*args)
        super
        rescue ActiveRecord::InvalidForeignKey => error
    end

    def self.index(current_user, query_params)
        current_user.account.roles
        .joins("
            left join (
                select 
                    count(1) user_count, 
                    roles_id 
                from user_roles 
                group by (roles_id)
            ) 
            users on users.roles_id = roles.id
        ")
        .order(object_level_permission: :desc, name: :asc)
        .select(:id, :name, :active, :only_my_data, :default_path, :object_level_permission, "users.user_count")
        
    end

    def show()
        data = Role
        .select(:id, :name, :active, :object_level_permission)
        .where("roles.id = ?", id)
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
            self.privileges.find_or_create_by(grant_object: route[:controller_path])
            self.privilege_defaults.find_or_create_by(grant_object: route[:controller_path])
        end
    end
end
