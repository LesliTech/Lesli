=begin
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

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

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end
class ApplicationLesliController < ApplicationController
    before_action :authenticate_user
    before_action :check_valid_account
    before_action :check_account
    
    layout 'layouts/application'

    def authenticate_user
        if !user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
        end
    end

    def check_valid_account

        return if current_user.blank?
        return if controller_name == "accounts"
        redirect_to "/accounts/new" if current_user.account.blank?

    end
    
    def check_account
        if current_user.account.lock.blank? && current_user.account.bell.blank?
            # insert reference to the core account
            current_user.account.bell = Bell.new
            current_user.account.bell.account = current_user.account
            current_user.account.bell.save!
            #Create a Lock for account
            current_user.account.lock = Lock.new
            current_user.account.lock.account = current_user.account
            current_user.account.lock.save!

            #Create a Lock_role to the Lock
            role= Lock::Role.new(
                name: "admin", 
                locks_id: current_user.account.lock.id)
            role.lock = current_user.account.lock
            role.save!

            #Create privileges to the lock_roles
            privilege = Lock::RolePrivilege.new(
                privilege_get: true,
                privilege_post: true,
                privilege_put: true,
                privilege_delete: true,
                lock_roles_id: current_user.account.lock.lock_roles )
            privilege.lock_role = role
            privilege.save!
            
        end

    def authenticate_user
        if !user_signed_in?
          #  notice: "Please Login to view that page!"
        end
    end

end
