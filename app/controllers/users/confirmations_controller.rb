# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
    layout 'application_devise'
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

        confirmation_token = params[:confirmation_token]

        user = User.find_by(confirmation_token: confirmation_token)

        user.confirmed_at = Time.now
        user.confirmation_token = nil

        user.save!

        #registration = UserServices::Registration.complete_registration(token)
        registration = { successful: true }

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
