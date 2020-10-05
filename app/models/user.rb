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
            :trackables 
    
    # users belongs to an account only and must have a role
    belongs_to :account, foreign_key: "accounts_id", optional: true
    belongs_to :role, foreign_key: "roles_id", optional: true
    

    # users has activities and personal settings
    has_many :logs,        foreign_key: "users_id"
    has_many :settings,    foreign_key: "users_id"
    has_many :sessions,    foreign_key: "users_id"
    has_many :requests,    foreign_key: "users_id"
    has_many :activities,  foreign_key: "users_id"
    has_many :privileges,  through: :role
    has_one  :role_detail, through: :role, source: :detail, class_name: "Role::Detail"
    has_one  :integration, foreign_key: "users_id"

    
    # user details are saved on separate table
    has_one :detail, inverse_of: :user, autosave: true, foreign_key: "users_id", dependent: :destroy 
    accepts_nested_attributes_for :detail, update_only: true

    after_create :initialize_user

    enum category: { user: "user", integration: "integration" }

    def user_creator
        return nil
    end

    def user_main
        return self
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
        roles = params[:role]         
        status = params[:status]
        
        users = []
        roles = roles.blank? ? [] : roles.split(',') 
        operator = type == "exclude" ? 'not in' : 'in'
        
        users = current_user.account.users
        .joins("inner join user_details UD on UD.users_id = users.id")
        .joins("inner join roles R on R.id = users.roles_id")
        .joins("inner join role_details RD on RD.roles_id = R.id")

        if (status != "all")
            users = users.where("users.active = ?", true)
        end
        
        # sort by name by default
        if query[:pagination][:orderColumn] == "id"
            query[:pagination][:orderColumn] = "first_name" 
            query[:pagination][:order] = "asc"
        end

        users = users.where("email like '%#{query[:filters][:domain]}%'")  unless query[:filters][:domain].blank?
        users = users.where("RD.name #{operator} (?)", roles) unless roles.blank?
        users = users.order("#{query[:pagination][:orderColumn]} #{query[:pagination][:order]} NULLS LAST")

        users.select(
            :id,
            :roles_id,
            :active,
            :email,
            "UD.first_name",
            "UD.last_name",
            "false as editable",
            "CONCAT(UD.first_name, ' ',UD.last_name) as name",
            "R.id as role_id",
            "RD.name as role_name"
        )

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
            roles_id: user[:roles_id],
            created_at: user[:created_at],
            updated_at: user[:updated_at],
            editable_security: current_user && current_user.is_role?("owner", "admin"),
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


    # @return [void]
    # @description Sets this user as inactive and removes complete access to the platform from them
    # @example
    #     old_user = User.last
    #     old_user.revoke_access
    def revoke_access
        update_attributes(active: false)
    end


    # Generate a new password token and sent via email
    def self.send_password_reset(user)
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        user.update(reset_password_token: hashed, reset_password_sent_at: LC::Date.now)
        data = {
            name: user[:name],
            email: user[:email],
        }
        email = LesliMailer.user_new_password("New user", data, raw)
        email.deliver_now
    end


    # save user activity
    def log_activity request_method, request_controller, request_action, request_url, description = nil
        self.activities.create({
            request_controller: request_controller,
            request_method: request_method,
            request_action: request_action,
            request_url: request_url,
            description: description
        })
    end


    # register a notification for the current user
    def notification subject, url:nil, category:"info"
        Courier::Bell::Notification::Web.new(self, subject, url:url, category:category)
    end


    # check role of the user
    def is_role? *roles
        return roles.include? self.role.detail.name
    end


    # validates unique email
    def save(*args)
        super
        rescue ActiveRecord::RecordNotUnique => error
    end
    

    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    #     At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    #     designed to be invoked directly
    # @example
    #     new_user = User.create(
    #         email: "john.doe@mail.com",
    #         password: "1234567890",
    #         password_confirmation: "1234567890"
    #     )
    # At this point, check_user will be invoked automatically
    def initialize_user
        
        User::Detail.find_or_create_by({ user: self })

        return if self.account.blank?

        if defined? CloudDriver
            self.account.driver.calendars.create({
                detail_attributes: {
                    name: "default",
                    default: true
                }
            })
        end

    end

end
