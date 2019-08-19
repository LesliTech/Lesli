# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
    # GET /resource/confirmation/new
    # def new
    #   super
    # end

    # POST /resource/confirmation
    # def create
    #   super
    # end

    # GET /resource/confirmation?confirmation_token=abcdef
    def show

        token = params[:confirmation_token]

        registration = UserServices::Registration.complete_registration(token)

        if registration[:successful]
            redirect_to root_path, notice: "User confirmed"
        else
            redirect_to register_path, error: registration.errors
        end

    end

    # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end
end
