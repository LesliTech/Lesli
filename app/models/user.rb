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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class User < ApplicationRecord
    devise  :database_authenticatable, 
            :registerable, 
            :rememberable, 
            :recoverable, 
            :validatable,
            :confirmable,
            :trackables 
    
    acts_as_paranoid

    belongs_to :account, foreign_key: "accounts_id", optional: true

    has_one :lock, class_name: "CloudLock::User", foreign_key: "users_id"

    after_initialize :assign_role
    after_create :user_initialize 

    validates :role, presence: true

    def save(*args)
        super
        rescue ActiveRecord::RecordNotUnique => error
    end

    enum roles: {
        admin: "admin",
        buyer: "buyer",
        manager: "manager",
        office_manager: "office_manager",
        property_manager: "property_manager",
        intern: "intern",
        b2b: "b2b",
        kop: "kop",
        callcenter: "callcenter",
        api: "api",
        guest: "guest"
    }

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
        name.blank? ? email : name
    end

    # @return [void]
    # @description Sets this user as inactive and removes complete access to the platform from them
    # @example
    #     old_user = User.last
    #     old_user.revoke_access
    def revoke_access
        update_attributes(active: false)
    end

    # @return Array
    # @description Return a list of users that belongs to the account of the current_user
    def self.list(current_user, query)
        current_user.account.users
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
    end

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

    # =begin
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
    # =end
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

    private 

    # @return [void]
    # @description Before creating a user, assing the role for create it.
    #               This is a *before_validation* method, and is not
    #               designed to be invoked directly
    def assign_role
        self.role ||= "guest"
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
    def user_initialize 

        if defined? CloudLock

            role_guest = CloudLock::Role
            .joins(:detail)
            .where("cloud_lock_role_details.name = ?", self.role)
            .first

            lock_user = CloudLock::User.new(
                account: self.account,
                user: self,
                role: role_guest,
                created_at: Time.now,
                updated_at: Time.now,
                detail_attributes: {}    
            )

            lock_user.save

        end

        if defined? CloudDriver
            self.account.driver.calendars.create({
                detail_attributes: {
                    name: self.name,
                    default: true
                }
            })
        end

    end

    # @return [Ability] All permissions this user has
    # @description Returns the permissions this user has as a *CanCan:Ability*
    # @example
    #     my_permissions = self.ability
    # def ability
    #    @ability ||= Ability.new(self)
    # end

end
