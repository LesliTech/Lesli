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

    belongs_to :account, foreign_key: 'accounts_id', optional: true

    has_one :lock_user, class_name: "CloudLock::User", foreign_key: "users_id"

    after_create :user_initialize 

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
        user.update(reset_password_token: hashed, reset_password_sent_at: Courier::Core::Date.now)
        data = {
            name: user[:name],
            email: user[:email],
        }
        email = LesliMailer.user_new_password("New user", data, raw)
        email.deliver_now
    end

    private 

    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    #     At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    #     designed to be invoked directly
    # @example
    #     new_user = User.create(
    #         email: 'john.doe@mail.com',
    #         password: '1234567890',
    #         password_confirmation: '1234567890'
    #     )
    # At this point, check_user will be invoked automatically
    def user_initialize 
        if defined? CloudLock
            #self.account.lock.user.create({
            #    login: self
            #})
        end
        if defined? CloudDriver
            return if self.account.driver.blank?
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
    def ability
        @ability ||= Ability.new(self)
    end

end
