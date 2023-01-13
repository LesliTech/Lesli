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

class User < ApplicationLesliRecord

    include UserGuard
    include UserExtensions
    include UserActivities
    include UserPolyfill

    acts_as_paranoid

    validates :email, :presence => true

    devise  :database_authenticatable,
            :registerable,
            :rememberable,
            :recoverable,
            :validatable,
            :confirmable,
            :trackable,
            :omniauthable, omniauth_providers: [:google_oauth2, :facebook]


    # user details are saved on separate table
    has_one :detail, inverse_of: :user, autosave: true, foreign_key: "users_id", dependent: :destroy
    accepts_nested_attributes_for :detail, update_only: true


    # users belongs to an account only... and must have a role
    belongs_to :account, foreign_key: "accounts_id", optional: true
    belongs_to :role, foreign_key: "roles_id", optional: true


    # users data extensions
    has_many :logs,             foreign_key: "users_id", inverse_of: :user
    has_many :settings,         foreign_key: "users_id"
    has_many :sessions,         foreign_key: "users_id"
    has_many :requests,         foreign_key: "users_id"
    has_many :webpushes,        foreign_key: "users_id"
    has_many :shortcuts,        foreign_key: "users_id"
    has_many :activities,       foreign_key: "users_id"
    has_one  :integration,      foreign_key: "users_id"
    has_many :access_codes,     foreign_key: "users_id"
    has_many :auth_providers,   foreign_key: "users_id"     


    # users can have many roles and too many privileges through the roles
    has_many :user_roles,       foreign_key: "users_id",    class_name: "User::Role"
    has_many :roles,            through: :user_roles,       source: :roles
    has_many :privileges,       through: :roles


    # user roles & privileges association compatibility
    # this comes from the first implementation of the role descriptors
    has_many :role_privileges,          through: :roles,            source: :privileges
    has_many :user_privilege_actions,   foreign_key: "users_id",    class_name: "User::PrivilegeAction"
    has_many :role_privilege_actions,   through: :roles,            source: :privilege_actions


    # callbacks
    before_create :before_create_user
    after_create :after_create_user


    # type of user
    #   system user
    #   integration apps
    enum category: { user: "user", integration: "integration" }


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def save(*args)
        super()
        rescue ActiveRecord::RecordNotUnique => error
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def user_creator
        return nil
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def user_main
        return self
    end


    # @return [void]
    # @description Before creating a user we make sure there is no capitalized email
    def before_create_user
        self.email = (self.email||"").downcase
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    #     At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    #     designed to be invoked directly
    def after_create_user

        # create user details
        User::Detail.find_or_create_by({ user: self })

        # create an alias based on user name
        self.set_alias

    end


    # Initialize user settings and dependencies needed
    def after_confirmation_user
        return unless self.confirmed?

        self.settings.create_with(:value => false).find_or_create_by(:name => "mfa_enabled")
        self.settings.create_with(:value => :email).find_or_create_by(:name => "mfa_method")

        return unless self.account
        Courier::One::Firebase::User.sync_user(self)
        Courier::Driver::Calendar.create_user_calendar(self, name: "Personal Calendar", default: true)
    end


    # @param accounnt [Account] The account associated to *current_user*
    # @param roles [String] The roles separate by comma for filter users by role
    # @param type [String] if type=exclude will remove users with roles listed in @param roles
    # @return [Array] Detailed information about all the users of this account.
    # @description Return a list of users that belongs to the account of the current_user
    # @example
    #     users_info = User.index(current_user.account, role)
    #     puts users_info.to_json
    # will print something like: [
    #    {
    #        "id":1,
    #        "created_at":"2020-01-08T16:23:10.976Z",
    #        "name":"Diego Alay"
    #        "role":"manager"
    #    },{
    #        "id":2,
    #        "created_at":"2020-01-10T16:23:10.976Z",
    #        "name":"Carlos Hermosilla"
    #        "role":"b2b"
    #    }
    #]
    def self.list(current_user, query, params)
        type = params[:type]

        roles = params[:role].split(",").map { |role| "'#{role}'" }.join(", ") if not params[:role].blank?

        operator = type == "exclude" ? 'not in' : 'in'

        users = current_user.account.users
        .joins("inner join user_details ud on ud.users_id = users.id")
        .joins("
            inner join (
                select
                    ur.users_id, string_agg(r.\"name\", ', ') role_names
                from user_roles ur
                join roles r
                    on r.id = ur.roles_id  #{roles.blank? ? "" : "and r.name #{operator} (#{roles})"}
                where ur.deleted_at is null
                group by ur.users_id
            ) roles on roles.users_id = users.id
        ")

        if (query[:filters][:status] != "all")
            users = users.where("users.active = ?", true)
        end

        # sort by name by default
        if query[:pagination][:orderColumn] == "id"
            query[:pagination][:orderColumn] = "first_name"
            query[:pagination][:order] = "asc"
        end

        users = users.where("email like '%#{query[:filters][:domain]}%'")  unless query[:filters][:domain].blank?
        users = users.order("#{query[:pagination][:orderColumn]} #{query[:pagination][:order]} NULLS LAST")

        users = users.select(
            :id,
            :active,
            :email,
            :current_sign_in_at,
            "false as editable",
            "CONCAT(ud.first_name, ' ',ud.last_name) as name",
            "role_names as roles"
        )
    end


    # @param accounnt [Account] The account associated to *current_user*
    # @param roles [String] The roles separate by comma for filter users by role
    # @param type [String] if type=exclude will remove users with roles listed in @param roles
    # @return [Array] Detailed information about all the users of this account.
    # @description Return a list of users that belongs to the account of the current_user
    # @example
    #     users_info = User.index(current_user.account, role)
    #     puts users_info.to_json
    # will print something like: [
    #    {
    #        "id":1,
    #        "created_at":"2020-01-08T16:23:10.976Z",
    #        "name":"Diego Alay"
    #        "role":"manager"
    #    },{
    #        "id":2,
    #        "created_at":"2020-01-10T16:23:10.976Z",
    #        "name":"Carlos Hermosilla"
    #        "role":"b2b"
    #    }
    #]
    def self.index(current_user, query, params)
        type = params[:type]

        operator = type == "exclude" ? 'not in' : 'in'

        # Filter users by roles
        unless params.dig(:f, :role).nil?
            roles = params[:f][:role].split(",").map { |role| "'#{role}'" }.join(", ") if not params[:f][:role].blank?
        end

        users = current_user.account.users
        .joins("inner join user_details ud on ud.users_id = users.id")
        .joins("
            inner join (
                select
                    ur.users_id, string_agg(r.\"name\", ', ') role_names
                from user_roles ur
                join roles r
                    on r.id = ur.roles_id  #{roles.blank? ? "" : "and r.id #{operator} (#{roles})"}
                where ur.deleted_at is null
                group by ur.users_id
            ) roles on roles.users_id = users.id
        ")
        .joins("
            left join (
                select
                    max(last_used_at) as last_action_performed_at,
                    max(created_at) as last_login_at,
                    users_id
                from user_sessions us
                where us.deleted_at is null
                group by(us.users_id)
            ) sessions on sessions.users_id = users.id
        ")
        .where("category = 'user'")

        users = users.where("email like '%#{query[:filters][:domain]}%'")  unless query[:filters][:domain].blank?
        users = users.where("
            lower(email) like '%#{query[:search]}%' or
            LOWER(concat(ud.first_name, ' ', ud.last_name)) like '%#{query[:search].downcase}%'
        ")  if not query[:search].blank?

        users = users.select(
            :id,
            :active,
            :email,
            :category,
            :current_sign_in_at,
            "false as editable",
            "CONCAT(ud.first_name, ' ',ud.last_name) as name",
            "role_names as roles",
            "sessions.last_action_performed_at",
            "sessions.last_login_at"
        )

        # Filter users by status
        
        unless params.dig(:f, :status).nil?
            if (params[:f][:status] == 'active')
                users = users.where("users.active = ?", true)
            elsif (params[:f][:status] == 'inactive')
                users = users.where("users.active = ?", false)
            end
        end

        users = users
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

    end


    # @return [Array] Paginated index of users.
    # @description Return a paginated array of users, used mostly in frontend views
    def self.index3(current_user, query, params)

        # sql string to join to user_roles and get all the roles assigned to a user
        sql_string_for_user_roles = "inner join (
            select
                ur.users_id, string_agg(r.\"name\", ', ') role_names
            from user_roles ur
            join roles r
                on r.id = ur.roles_id  
            where ur.deleted_at is null
            group by ur.users_id
        ) roles on roles.users_id = users.id"

        # sql string to joing to user_sessions and get all the active sessions of a user
        sql_string_for_user_sessions = "left join (
            select
                max(last_used_at) as last_action_performed_at,
                max(created_at) as last_login_at,
                users_id
            from user_sessions us
            where us.deleted_at is null
            group by(us.users_id)
        ) sessions on sessions.users_id = users.id"

        users = current_user.account.users
        .joins(:detail)
        .joins(sql_string_for_user_roles)
        .joins(sql_string_for_user_sessions)
        .where("category = 'user'")


        if query.dig(:search)
            users = users.where(
                "lower(users.email) like :search or lower(concat(user_details.first_name, ' ', user_details.last_name)) like :search", 
                { search: "%#{sanitize_sql_like(query.dig(:search))}%" }
            )
        end

        users = users.select(
            :id,
            :active,
            :email,
            :role_names,
            "CONCAT(user_details.first_name, ' ',user_details.last_name) as name",
            "current_sign_in_at as current_signin_at",
            :last_action_performed_at,
            :last_login_at,
            "false as editable"
        )

        return users
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

    end


    # @return [Hash] Detailed information about the user.
    # @description Creates a query that selects all user information from several tables if CloudLock is present
    #     and returns it in a hash
    # @example
    #     user = User.find(43)
    #     puts user.show
    #     will print something like: {
    #        "id":1,
    #        "created_at":"2020-01-08T16:23:10.976Z",
    #        "name":"Diego Alay"
    #        "role":"manager"
    #     }
    def show(current_user = nil)
        user = self.account.users.find(id)

        return {
            id: user[:id],
            email: user[:email],
            alias: user[:alias],
            active: user[:active],
            created_at: user[:created_at],
            updated_at: user[:updated_at],
            editable_security: current_user && current_user.has_roles?("owner", "sysadmin"),
            roles: user.roles.map { |r| { id: r[:id], name: r[:name], permission_level: r[:object_level_permission]} },
            full_name: user.full_name,
            mfa_enabled: user.mfa_settings[:enabled],
            mfa_method:  user.mfa_settings[:method],
            language: user.settings.find_by(:name => "locale"),
            detail_attributes: {
                title: user.detail[:title],
                salutation: user.detail[:salutation],
                first_name: user.detail[:first_name],
                last_name: user.detail[:last_name],
                telephone: user.detail[:telephone],
                address: user.detail[:address],
                work_city: user.detail[:work_city],
                work_region: user.detail[:work_region],
                work_address: user.detail[:work_address]
            }
        }

    end

end
