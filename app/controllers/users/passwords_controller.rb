# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout 'application_public'
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    super do |resource|
      if successfully_sent?(resource)
        return responseWithSuccessful
      else
        return responseWithError(t('devise.errors.custom.password_email_not_sent'))
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
