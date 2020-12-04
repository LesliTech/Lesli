class User::PasswordsController < ApplicationLesliController

    # GET /user/passwords/1/edit
    def edit
    end

    # POST /user/passwords
    def create
    end

    # PATCH/PUT /user/passwords/1
    def update

        @user = current_user

        log = @user.logs.create({ session_uuid: nil, description: "password_update_atempt" })

        if @user.update(user_password_params)

            # reset password expiration due the user just updated his password
            if @user.is_password_expired?
                @user.update_attributes(password_expiration_at: nil)
            end 

            # Sign in the user by passing validation in case their password changed
            bypass_sign_in(@user)

            respond_with_successful

            log.update_attribute(:description, "password_update_successful")

        else

            respond_with_error(@user.errors.full_messages.to_sentence)

            log.update_attribute(:description, "password_update_error")

        end
        
    end

    private

    # Only allow a trusted parameter "white list" through.
    def user_password_params
        params.require(:user).permit(:email, :password, :password_confirmation, :password_expiration_at)
    end
    
end
