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

class User < ApplicationLesliRecord

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


    # users belongs to an account only and must have a role
    belongs_to :account, foreign_key: "accounts_id", optional: true
    belongs_to :role, foreign_key: "roles_id", optional: true


    # users has activities and personal settings
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

    has_many :user_roles,       foreign_key: "users_id",    class_name: "User::Role"
    has_many :roles,            through: :user_roles,       source: :roles
    has_many :privileges,       through: :roles

    has_many :role_privileges,          through: :roles,            source: :privileges
    has_many :user_privilege_actions,   foreign_key: "users_id",    class_name: "User::PrivilegeAction"
    has_many :role_privilege_actions,   through: :roles,            source: :privilege_actions


    # user details are saved on separate table
    has_one :detail, inverse_of: :user, autosave: true, foreign_key: "users_id", dependent: :destroy
    accepts_nested_attributes_for :detail, update_only: true

    before_create :initialize_user
    after_create :initialize_user_details
    after_update :change_after_update

    # type of user
    #   system user
    #   integration apps
    enum category: { user: "user", integration: "integration" }


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def save(*args)
        super
        rescue ActiveRecord::RecordNotUnique => error
    end



    # @return [void]
    # @description Before creating a user we make sure there is no capitalized email
    def initialize_user
        self.email = (self.email||"").downcase
    end



    def change_after_update
        self.initialize_user_after_confirmation if self.confirmed?
    end



    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    #     At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    #     designed to be invoked directly

    def initialize_user_details

        # create user details
        User::Detail.find_or_create_by({ user: self })

        # create an alias based on user name
        self.set_alias

    end 



    def initialize_user_after_confirmation
        Courier::One::Firebase::User.sync_user(self)
        Courier::Driver::Calendar.create_user_calendar(self, "Personal Calendar")
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
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    # @param *roles [String] One or more roles to be checked
    # check role of the user
    def has_roles? *roles
        !roles.intersection(self.roles.map{ |r| r[:name] }).empty?
    end

    # @return [Boolean]
    # @description Return true/false if a user has all the privileges to do an action based on a controllers list,
    #     this validation includes the privileges that the user could have based on its roles and the privileges
    #     that has been added to the specific user.
    # @examples
    #     validate privileges on a controller with the same actions on each one
    #     controllers = ["cloud_house/companies", "cloud_house/projects"]
    #     actions = ["index", "update"]
    #
    #     current_user.has_privileges?(controllers, actions)
    def has_privileges4?(controller, action, form='html')

        # set html by default, even if nil is sent as parameter for "form"
        form ||= 'html'

        begin
            self.privileges
            .where("role_privileges.controller = ?", controller)
            .where("role_privileges.action = ?", action)
            .where("role_privileges.form = ?", form)
            .first.blank?
        rescue => exception
            Honeybadger.notify(exception)
            return false
        end
    end

    def has_privileges?(controllers, actions)

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

    # @return [Hash]
    # @description Return a hash that contains all the abilities grouped by controller and define every action privilege. It also
    #     evaluate if the user has the ability no matter if is given to the user by role or by itself.
    # @examples
    #     current_user.abilities_by_controller
    def abilities_by_controller

        # Due this method is executed on every HTML request, we use low level cache to improve performance
        # It is not usual to the privileges to change so often, however the cache will be deleted
        # after every commit on roles, role descriptors and privileges
        #Rails.cache.fetch(user_cache_key(abilities_by_controller, self), expires_in: 12.hours) do

            abilities = {}

            # Evaluate role privileges
            self.role_privilege_actions
            .select("
                bool_or(role_descriptor_privilege_actions.status) as value,
                system_controller_actions.name as action,
                system_controllers.name as controller
            ")
            .joins(system_action: [:system_controller])
            .group("
                system_controller_actions.name,
                system_controllers.name
            ")
            .each do |route|
                abilities[route["controller"]] = {} if abilities[route["controller"]].nil?
                abilities[route["controller"]][route["action"]] = route["value"]
            end

            # Evaluate user privileges
            self.user_privilege_actions
            .select("
                bool_or(status) as value,
                system_controller_actions.name as action,
                system_controllers.name as controller
            ")
            .joins(system_action: [:system_controller])
            .group("
                system_controller_actions.name,
                system_controllers.name
            ")
            .each do |route|
                abilities[route["controller"]] = {} if abilities[route["controller"]].nil?
                # If privilege is granted by role or by user keep it as granted
                abilities[route["controller"]][route["action"]] = abilities[route["controller"]][route["action"]] || route["value"]
            end

            abilities

        #end
    end



    # @return Boolean
    # @description Check if user has enough privilege to work with the given role
    def can_work_with_role?(role)

        # get the role if only id is given
        role = self.roles.find_by(:id => role) unless role.class.name == "Role"

        # false if role not found
        return false if role.blank?

        # not valid role without object levelpermission defined
        return false if role.object_level_permission.blank?

        # get the max object level permission from the roles the user has assigned
        user_role_level_max = self.roles.map(&:object_level_permission).max()

        LC::Debug.msg(!self.roles.find_by(name: 'owner').blank?, role.object_level_permission, user_role_level_max)

        # owner role can work with all the roles
        return true if !self.roles.find_by(name: 'owner').blank?

        # check if user can work with the object level permission of the role is trying to modify
        # Note: user only can assigned an object level permission below the max of his own roles
        # Current user cannot assign role if
        #       role to assign has greater object level permission than the greater role assigned to the current user
        #       role to assign is the same of the greater role assigned to the current user
        #       current user is not sysadmin or owner
        return false if role.object_level_permission >= user_role_level_max

        return true

    end    



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


    # @return [void]
    # @description Sets this user as inactive and removes complete access to the platform from them
    # @example
    #     old_user = User.last
    #     old_user.revoke_access
    def revoke_access
        self.update(active: false)
    end



    # @return [void]
    # @description Change user password forcing user to reset the password
    def set_password_as_expired
        self.update(password_expiration_at: Time.current)
    end



    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def has_expired_password?
        return false if self.password_expiration_at.blank?
        return Time.current > self.password_expiration_at
    end



    # @return String
    # @description Change user password forcing user to reset the password
    def generate_password_reset_token
        raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

        self.reset_password_token   = enc
        self.reset_password_sent_at = Time.now.utc
        save(validate: false)
        raw
    end



    # @return [void]
    # @description Register a new notification for the current user
    # @param subject String Short notification description
    # @param body String Long notification description
    # @param url String Link to notified object
    # @param category String Kind of notification: info, warning, danger, success.
    def notification subject, body:nil, url:nil, category:"info"
        Courier::Bell::Notification.new(self, subject, body:body, url:url, category:category)
    end



    # @return [void]
    # @description Register a new log for the current user
    # @param description String Details about the process
    # @param session String Current or active session id
    def log description, session=nil
        self.logs.create(session, description)
    end



    # @return [String] The name of this user.
    # @description Retrieves and returns the name of the user depending on the available information.
    #     The name can be a full name (first and last names), just the first name, or, in case the information
    #     is not available, the email. This method currently is available if the the CloudLock engine exists,
    #     otherwise, it returns *nil*
    # @example
    #     my_user = current_user
    #     puts my_user.name # can print John Doe
    #     other_user = User.last
    #     puts other_user.name # can print jane.smith@email.com
    def full_name
        (detail.blank? || detail.first_name.blank?) ? email : detail.first_name + " " + detail.last_name.to_s
    end



    # @return [String] The name initials of this user.
    # @description Retrieves and returns the name initials of the user depending on the available information.
    # @example
    #     puts current_user.full_name_initials # would print JD
    def full_name_initials
        detail.first_name.blank? ? "" : detail.first_name[0].upcase + "" + (detail.last_name.blank? ? "" : detail.last_name[0].upcase)
    end


    # @return [nil]
    # @description Set the user alias based on the full_name.
    # @example
    #     puts current_user.full_name # John Doe
    #     puts current_user.set_alias # Jo. Do.
    def set_alias
        if self.alias.nil?
            self.alias = (detail&.first_name && detail&.last_name) ? "#{detail.first_name[0..1]}#{detail.last_name[0..1]}" : ""
            self.save
        end
    end

    # @return [String]
    # @description Returns the local configuration for the user if there is no locale the default local
    # of the platform will be returned
    # @example
    #      locale = User.last.locle
    #      will print something like: :es
    def locale
        user_locale = settings.find_by(name: "locale")

        if user_locale
            return user_locale.value.to_sym
        end

        I18n.locale # return current locale
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

        users = users.where("email like '%#{query[:filters][:domain]}%'")  unless query[:filters][:domain].blank?
        users = users.where("category = ?", query[:filters][:category]) if query[:filters][:category]
        users = users.where("
            lower(email) like '%#{query[:filters][:search]}%' or
            LOWER(concat(ud.first_name, ' ', ud.last_name)) like '%#{query[:filters][:search].downcase}%'
        ")  if not query[:filters][:search].blank?

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

        if (query[:filters][:status] == 'active')
            users = users.where("users.active = ?", true)
        elsif (query[:filters][:status] == 'inactive')
            users = users.where("users.active = ?", false)
        end

        users = users
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
            roles: user.roles.map { |r| { id: r[:id], name: r[:name] } },
            full_name: user.full_name,
            mfa_enabled: user.mfa_settings[:enabled],
            mfa_method:  user.mfa_settings[:method],
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

    # @return [void]
    # @description Returns MFA settings configured by the user
    # Example
    #   user_mfa_settings = User.find(2).mfa_settings
    #   puts user_mfa_settings
    #       { :mfa_enabled => true, :mfa_method => "email"}
    def mfa_settings
        mfa_enabled = self.settings.find_by(:name => "mfa_enabled")
        mfa_method = self.settings.find_by(:name => "mfa_method")
        
        is_mfa_enabled = false
        is_mfa_enabled ||= (mfa_enabled.value.downcase == "true") unless mfa_enabled.nil?

        {   
            :enabled => is_mfa_enabled,
            :method => mfa_method.nil? ? nil : mfa_method.value.to_sym
        }
    end

    #######################################################################################
    ##############################  Activities Log Methods   ##############################
    #######################################################################################

    # @return [void]
    # @param current_user [::User] The user that created the user
    # @param [User] The user that was created
    # @description Creates an activity for this user indicating who created it.
    # Example
    #   params = {...}
    #   user = User.create(params)
    #   User.log_activity_create(User.find(1), user)
    def self.log_activity_create(current_user, user)
        user.activities.create(
            owner: current_user,
            category: "action_create"
        )
    end


    # @return [void]
    # @param current_user [::User] The user that created the user
    # @param user [User] The User that was created
    # @param old_attributes[Hash] The data of the record before update
    # @param new_attributes[Hash] The data of the record after update
    # @description Creates an activity for this user if someone changed any of this values
    # Example
    #   user = User.find(1)
    #   old_attributes  = user.attributes.merge({detail_attributes: user.detail.attributes})
    #   user.update(main_employee: User.find(33))
    #   new_attributes = user.attributes.merge({detail_attributes: user.detail.attributes})
    #   User.log_activity_update(User.find(1), user, old_attributes, new_attributes)
    def self.log_activity_update(current_user, user, old_attributes, new_attributes)
        old_attributes.except!("id", "users_id", "created_at", "updated_at", "deleted_at")
        old_attributes.each do |key, value|
            if value != new_attributes[key]
                value_from = value
                value_to = new_attributes[key]
                value_from = Courier::Core::Date.to_string_datetime(value_from) if value_from.is_a?(Time) || value_from.is_a?(Date)
                value_to = Courier::Core::Date.to_string_datetime(value_to) if value_to.is_a?(Time) || value_to.is_a?(Date)

                user.activities.create(
                    owner: current_user,
                    category: "action_update",
                    field_name: key,
                    value_from: value_from,
                    value_to: value_to
                )
            end
        end
    end

    # @return [void]
    # @param current_user [::User] The user that created the user
    # @param user [User] The User that was created
    # @param user [Role] The Role assigned to the user
    # @description Creates an activity for this user if someone adds a new role
    # Example
    #   user = User.find(1)
    #   role = User.find(1)
    #   user.log_activity_create_user_role(current_user, user, role)
    def self.log_activity_create_user_role(current_user, user, role)
        role_name = role.name

        user.activities.create(
            owner: current_user,
            category: "action_create_user_role",
            value_to: role_name
        )
    end

    # @return [void]
    # @param current_user [::User] The user that created the user
    # @param user [User] The User that was created
    # @param user [Role] The Role assigned to the user
    # @description Creates an activity for this user if someone removes a role
    # Example
    #   user = User.find(1)
    #   role = User.find(1)
    #   user.log_activity_destroy_user_role(current_user, user, role)
    def self.log_activity_destroy_user_role(current_user, user, role)
        role_name = role.name

        user.activities.create(
            owner: current_user,
            category: "action_destroy_user_role",
            value_to: role_name
        )
    end

    # DEPRECATED

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
