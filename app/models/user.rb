=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class User < ApplicationRecord

    acts_as_paranoid

    devise  :database_authenticatable, 
            :registerable, 
            :rememberable, 
            :recoverable, 
            :validatable,
            :confirmable,
            :trackables 
    
    belongs_to :account, foreign_key: "accounts_id", optional: true
    belongs_to :role, foreign_key: "roles_id"

    has_many :activities, class_name: "User::Activity", foreign_key: "users_id"
    has_many :privileges, class_name: "User::Setting", foreign_key: "users_id"

    has_one :detail, inverse_of: :user, autosave: true, foreign_key: "users_id", dependent: :destroy 
    accepts_nested_attributes_for :detail, update_only: true

    after_create :initialize_user 

    validates :role, presence: true



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
    def self.list(current_user, roles, type, query)

        users = []
        roles = roles.blank? ? [] : roles.split(',') 
        operator = type == "exclude" ? 'not in' : 'in'
        if defined? (CloudLock)
            users = current_user.account.users
            .joins(:lock)
            .joins("left join cloud_lock_user_details as clud on clud.cloud_lock_users_id = cloud_lock_users.id")
            .joins("left join cloud_lock_roles as clr on clr.id = cloud_lock_users.cloud_lock_roles_id")
            .joins("left join cloud_lock_role_details as clrd on clrd.cloud_lock_roles_id = clr.id")
            .select(
                "users.id",
                "users.email",
                "users.active",
                "users.created_at",
                "clrd.name as role",
                "concat(clud.first_name, ' ', clud.last_name) as name",
            )
            .where(active: true)
            .order(:name)         
        else
            users = current_user.account.users.select(:id, :email, :role, :active, :name).order(:name)
        end

        users = users.where("email like '%#{query[:filters][:domain]}%'")  unless query[:filters][:domain].blank?
        users = users.where("role #{operator} (?)", roles) unless roles.blank?
        users.map do |user|
            {
                id: user[:id],
                email: user[:email],
                name: user[:name] != " " ? user[:name] : user[:email],
                role: user[:role],
                active: user[:active],
                created_at: user[:created_at]
            }
        end

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
    def show
        if defined? (CloudLock)
            user = User.find(id)
            user_lock = user.lock
            return {
                id: id,
                email: email,
                lock: {
                    id: user_lock.id,
                    users_id: user_lock.users_id,
                    detail_attributes: user_lock.detail,
                    cloud_lock_roles_id: user_lock.cloud_lock_roles_id,
                }
            }
        else
            return User.select(:id, :email, :role, :name).find(id)
        end  
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
        log " deactivated"
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
    def log title, description = ""
        self.activities.create({
            title: title,
            description: description
        })
    end


    # register a notification for the current user
    def notification subject, url:nil, category:"info"
        Courier::Bell::Notification::Web.new(self, subject, url:url, category:category)
    end


    # check role of the user
    def role_is? role=nil
        puts "#     #     #     #     #     #     #     #     #"
        puts "#     #     #     #     #     #     #     #     #"
        puts "#     #     #     #     #     #     #     #     #"
        p self.role
        puts "#     #     #     #     #     #     #     #     #"
        puts "#     #     #     #     #     #     #     #     #"
        puts "#     #     #     #     #     #     #     #     #"
        return "self.role"
    end


    # validates unique email
    def save(*args)
        super
        rescue ActiveRecord::RecordNotUnique => error
    end

    private 
    

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

        User::Detail.create({user: self})

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
