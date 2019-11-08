class ApplicationLesliController < ApplicationController
    before_action :authenticate_user!
    before_action :check_valid_account
    layout 'layouts/application'

    def check_valid_account

        return if current_user.blank?
        return if controller_name == "accounts"

        redirect_to "/accounts/new" if current_user.account.blank?

    end

end
