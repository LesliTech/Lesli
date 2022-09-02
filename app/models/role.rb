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

    belongs_to :account,                foreign_key: "accounts_id"

    has_many :activities,               foreign_key: "roles_id"
    has_many :privileges,               foreign_key: "roles_id",    class_name: "Role::Privilege",  dependent: :delete_all
    has_many :describers,               foreign_key: "roles_id"
    has_many :descriptor_assignments,   foreign_key: "roles_id",    class_name: "DescriptorAssignment",  dependent: :delete_all
    has_many :privilege_actions,        through: :descriptor_assignments

    before_create :initialize_role
    after_create :generate_code

    validates :name, presence: :true
    validates :object_level_permission, presence: :true


    def initialize_role

        # default role for limited roles
        if ["limited", "guest"].include? self.name
            self.default_path ||= "/administration/profile" # profile path
        end

        # enable roles by default
        self.active = true

    end

    def generate_code
        role_code = name
            .downcase                           # string to lowercase
            .gsub(/[^0-9A-Za-z\s\-\_]/, '')     # remove special characters from string
            .gsub(/-/, '_')                     # replace dashes with underscore
            .gsub(/\s+/, '_')                   # replace spaces or spaces with single dash

        role_code = I18n.transliterate(role_code) + id.to_s # transform UTF-8 characters to ASCI

        self.update_attribute('code', role_code)
    end

    def self.list current_user, query

        role_max = current_user.roles.map(&:object_level_permission).max()

        unless query[:filters][:object_level_permission].blank?
            role_max = query[:filters][:object_level_permission] if query[:filters][:object_level_permission].to_i <= role_max
        end

        roles = current_user.account.roles.select(:id, :name, :object_level_permission)

        roles = roles.where("object_level_permission <= ?", role_max)
        roles = roles.order(object_level_permission: :desc, name: :asc)
    end

    def self.index(current_user, query)
        role_max = current_user.roles.map(&:object_level_permission).max()

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
        .where("roles.object_level_permission <= ?", role_max)
        .order(object_level_permission: :desc, name: :asc)
        .select(:id, :name, :active, :only_my_data, :default_path, :object_level_permission, "users.user_count")

        unless query[:filters].blank?
            roles = roles.where("lower(roles.name) like ?", "%#{query[:filters][:text].downcase.strip}%") unless query[:filters][:text].blank?

            unless query[:filters][:object_level_permission].blank?
                role_max = query[:filters][:object_level_permission] if query[:filters][:object_level_permission].to_i <= role_max
            end

            
        end

        roles
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(object_level_permission: :desc, name: :asc)

    end

    def show
        {
            :id => self.id,
            :name => self.name,
            :active => self.active,
            :default_path => self.default_path,
            :only_my_data => self.only_my_data,
            :object_level_permission => self.object_level_permission,
            :created_at => self.created_at,
            :updated_at => self.updated_at,
            :descriptors => self.describers.joins(:descriptor).select(:id, :name, :code, :path, :descriptors_id)
        }
    end

    # @return [void]
    # @description Creates all privileges for this role in default false value. The task app:routes:build cannot be used
    #   because it is a rake task, and because it scans routes for all roles, and it would be very inefficient
    # @example
    #   role = Role.new(detail_attributes: {name: "test_role", object_level_permission: 10})
    #   # This method will be called automatically within an after_create callback
    #   puts role.privileges.to_json # Should display all privileges that existed at the moment of the role's creation
    # DEPRECATED
    def initialize_role_privileges
        if (self.name == "sysadmin" || self.name == "owner")
            self.descriptor_assignments
            .find_or_create_by(
                descriptor: self.account.role_descriptors.find_by(name: self.name)
            )
        end

        # assign ["show", "update"] actions from profile descriptor to the role
        ["show", "update"].each do |category|
            self.descriptor_assignments
            .find_or_create_by(
                descriptor: self.account.role_descriptors.find_by(name: "profile"),
                category: category
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
