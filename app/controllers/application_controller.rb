class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :check_if_user_has_valid_account

    def check_if_user_has_valid_account
        return if controller_name == "accounts"
        redirect_to main_app.account_path if  current_user.account.blank?
    end

end
