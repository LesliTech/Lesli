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

    belongs_to :account,   foreign_key: "accounts_id"

    has_many :activities,  foreign_key: "roles_id"
    has_many :descriptors, foreign_key: "roles_id", dependent: :delete_all
    has_many :privileges,  foreign_key: "roles_id", class_name: "Role::Privilege", dependent: :delete_all
    

    before_create :before_create_role
    after_create :after_create_role, :initialize_role_privileges

    validates :name, presence: :true
    validates :object_level_permission, presence: :true


    def before_create_role

        # default role for limited roles
        if self.name == "limited"
           self.path_default ||= "/administration/profile" # profile path
        end

        # enable roles by default
        self.active = true

    end

    def after_create_role
        role_code = name
            .downcase                           # string to lowercase
            .gsub(/[^0-9A-Za-z\s\-\_]/, '')     # remove special characters from string
            .gsub(/-/, '_')                     # replace dashes with underscore
            .gsub(/\s+/, '_')                   # replace spaces or spaces with single dash

        role_code = I18n.transliterate(role_code) + id.to_s # transform UTF-8 characters to ASCI

        self.update_attribute("code", role_code)
    end

    # @return [void]
    # @description Creates all privileges for this role in default false value. The task app:routes:build cannot be used
    #   because it is a rake task, and because it scans routes for all roles, and it would be very inefficient
    # @example
    #   role = Role.new(detail_attributes: {name: "test_role", object_level_permission: 10})
    #   # This method will be called automatically within an after_create callback
    #   puts role.privileges.to_json # Should display all privileges that existed at the moment of the role's creation
    def initialize_role_privileges
        return 
        if (self.name == "owner" || self.name == "sysadmin" || self.name == "limited")
            descriptor = self.name
            descriptor = "profile" if descriptor == "limited"
            SystemDescriptor.find_or_create_by(
                descriptor: SystemDescriptor.find_by(name: descriptor)
            )
        end
    end

    # @return [Boolean]
    # @description Returns if a role it is assigned to users.
    def has_users?
        User::Role.where(role: self).count > 0
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
end
