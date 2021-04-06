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
            :trackable 
    

    # users belongs to an account only and must have a role
    belongs_to :account, foreign_key: "accounts_id", optional: true
    belongs_to :role, foreign_key: "roles_id", optional: true
    

    # users has activities and personal settings
    has_many :logs,         foreign_key: "users_id", inverse_of: :user
    has_many :settings,     foreign_key: "users_id"
    has_many :sessions,     foreign_key: "users_id"
    has_many :requests,     foreign_key: "users_id"
    has_many :activities,   foreign_key: "users_id"
    has_one  :integration,  foreign_key: "users_id"
    has_many :access_codes, foreign_key: "users_id"

    has_many :user_roles,   foreign_key: "users_id", class_name: "User::Role"
    has_many :roles,        through: :user_roles, :source => "roles"
    has_many :privileges,   through: :roles

    
    # user details are saved on separate table
    has_one :detail, inverse_of: :user, autosave: true, foreign_key: "users_id", dependent: :destroy 
    accepts_nested_attributes_for :detail, update_only: true

    before_create :initialize_user
    after_create :initialize_user_details

    before_destroy :destroy_user

    # type of user
    #   system user
    #   integration apps
    enum category: { user: "user", integration: "integration" }


    # @return [void]
    # @description Before creating a user we make sure there is no capitalized email
    def initialize_user
        self.email = (self.email||"").downcase
    end

    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    #     At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    #     designed to be invoked directly
    def initialize_user_details
        User::Detail.find_or_create_by({ user: self })
    end



    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def save(*args)
        super
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
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    # check role of the user
    def has_roles? *roles
        !roles.intersection(self.roles.map{ |r| r[:name] }).empty?
    end



    # @return [Boolean]
    # @description Return true/false if a user has the privileges to do an action based on a controllers list
    # @examples 
    #     validate privileges on a controller with the same actions on each one
    #     controllers = ["cloud_house/companies", "cloud_house/projects"]
    #     actions = ["index"]
    # 
    #     current_user.has_privileges?(controllers, actions)
    def has_privileges?(controllers, actions) 
        actions = actions.map { |action| "bool_or(grant_#{action})" }.join(" and ")

        granted = self.privileges
        .where(grant_object: controllers)
        .select(actions + " as value ")
        .map(&:value)

        return granted[0]
    rescue => exception
        Honeybadger.notify(exception)
        return false    
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



    # @return Boolean
    # @description Check if user has enough privilege to work with the given role
    def can_work_with_role?(role_id)

        return false if role_id.blank?

        role = self.account.roles.find(role_id) rescue nil

        return false if role.blank?

        # check if the current_user can assign this role, current user cannot assign role if
        #   role to assign has greater object level permission than the greater role assigned to the current user
        #   role to assign is the same of the greater role assigned to the current user
        #   current user is not admin or owner
        self.roles.each do |current_role|
            return true if current_role.object_level_permission > role.object_level_permission 
            return true if current_role.name == "owner"
        end

        return false

    end



    # @return [void]
    # @description Register a new notification for the current user
    # @param subject String Short notification description
    # @param body String Long notification description
    # @param url String Link to notified object
    # @param category String Kind of notification: info, warning, danger, success.
    def notification subject, body:nil, url:nil, category:"info"
        Courier::Bell::Notification.new(self, subject, body:nil, url:nil, category:nil)
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
        detail.first_name.blank? ? email : detail.first_name + " " + detail.last_name.to_s
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

        users = users.where("role_names #{operator} (#{roles})") unless roles.blank?
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

        users = users.where("email like '%#{query[:filters][:domain]}%'")  unless query[:filters][:domain].blank?
        users = users.where("role_names #{operator} (#{roles})") unless roles.blank?
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
            "role_names as roles"
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
        
        users_count = users.total_count

        users = users.map do |user|

            # last time user use the login form to access the platform
            last_sign_in_at = LC::Date.distance_to_words(user[:current_sign_in_at], Time.current)

            # last action the user perform an action into the system
            last_action_performed_at = user.requests.last 
            last_action_performed_at = LC::Date.distance_to_words(last_action_performed_at[:created_at], Time.current) if not last_action_performed_at.blank?

            # check if user has an active session
            session = user.sessions.last ? true : false

            {
                id: user[:id],
                name: user[:name],
                email: user[:email],
                category: user[:category],
                last_sign_in_at: last_sign_in_at,
                active: user[:active],
                roles: user.roles,
                last_activity_at: last_action_performed_at,
                session_active: session 
            }
        end        

        return {
            users_count: users_count,
            users: users
        }

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
            active: user[:active],
            created_at: user[:created_at],
            updated_at: user[:updated_at],
            editable_security: current_user && current_user.has_roles?("owner", "admin"),
            roles: user.roles.map { |r| { id: r[:id], name: r[:name] } },
            full_name: user.full_name,
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

    # Change the email so it will be able for a re-register
    def destroy_user
        new_email = "#{self.id}-#{self.email}"
        ActiveRecord::Base.connection.exec_query("UPDATE users SET email = '#{new_email}' WHERE id = #{self.id}")
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
        LC::Debug.msg "DEPRECATED: Use user.activities, user.logs or log_user_comments instead"
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
