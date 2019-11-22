class ApplicationLesliController < ApplicationController
    before_action :check_valid_account
    before_action :check_account
    before_action :authenticate_user
    
    layout 'layouts/application'


    def check_valid_account

        return if current_user.blank?
        return if controller_name == "accounts"

        redirect_to "/accounts/new" if current_user.account.blank?

    end

    def check_account
        if current_user.account.bell.blank?
            # insert reference to the core account
            current_user.account.bell = Bell.new
            current_user.account.bell.account = current_user.account
            current_user.account.bell.save!
        end
    end

    def authenticate_user
        if !user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
        end
    end

end
