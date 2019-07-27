# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
    layout 'application_empty'
    before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    # GET /resource/sign_up
    def new
        return redirect_to register_path if request.original_url.include?('users')
        super
    end

    # POST /resource
    def create
        
        user = build_resource(sign_up_params)
        
        if user.save
            redirect_to root_path, notice: "Registration"
        else
            redirect_to register_path, error: user.errors.full_messages[0]
        end
        
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
end
