class ApplicationLesliController < ApplicationController
    before_action :authenticate_user!
    before_action :check_valid_account
    layout 'layouts/application'

    def check_valid_account

        return if current_user.blank?
        return if controller_name == "accounts"

        redirect_to "/accounts/new" if current_user.account.blank?

    end

    def responseWithSuccessful(data = nil)
        render status: 200, json: {
            successful: true,
            data: data
        }.to_json
    end

    def responseWithError(message = "", details = nil)
        render status: 200, json: {
            successful: false,
            error: {
                message: message,
                details: details
            }
        }.to_json
    end

end
