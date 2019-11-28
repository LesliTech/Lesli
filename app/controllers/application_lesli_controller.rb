class ApplicationLesliController < ApplicationController
    before_action :check_valid_account
    before_action :check_account
    before_action :check_detail
    before_action :authenticate_user
    
    layout 'layouts/application'


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
    end

    def check_detail

        return if current_user.detail.blank?
        return if controller_name == "details"
        redirect_to "/user/details/new" if current_user.details.blank?

    end

    def authenticate_user
        if !user_signed_in?
          #  notice: "Please Login to view that page!"
        end
    end

end
