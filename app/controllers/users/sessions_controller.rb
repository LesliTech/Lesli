# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
    layout 'application_public'
    # before_action :configure_sign_in_params, only: [:create]

    # POST /resource/sign_in
    def create
        params = sign_in_params
        resource = User.find_for_database_authentication(email: params[:email])
        return invalid_login_attempt unless resource
     
        if resource.valid_password?(params[:password])
            sign_in :user, resource
            return responseWithSuccessful
        end
     
        invalid_login_attempt
    end

    private

    # Register invalid login attempt
    def invalid_login_attempt
        responseWithError(t('devise.errors.custom.invalid_credentials'))
    end

    # Configuring the sign_in parameters
    def sign_in_params
        params.fetch(:sign_in, {}).permit(:email, :password)
    end
end
