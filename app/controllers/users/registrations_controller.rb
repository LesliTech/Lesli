=begin

Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create, :update]


    #@return [Symbol] Symbol representing the name of the resource handled by this controller.
    #@description Returns the *:user* symbol, which is the name of the class handler by this controller
    #@example
    #    puts resource_name # prints "user"
    def resource_name
        :user
    end


    #@return [User] The user handler by the current instance of this controller.
    #@description Returns the user associated to this controller. If there is no
    #    user, a new instance is created and returned
    #@example
    #    x = resource # x will be an instance of User
    def resource
        @resource ||= User.new
    end


    #@return [HTML]
    #@description returns an HTML view with a form so users can register on the platform
    #@example
    #    # Executing this controller's action from javascript's frontend
    #    this.url.go('/register')
    def new
        return redirect_to register_path if request.original_url.include?('users')
        super
    end


    #@controller_action_param :email [String] The registered user email
    #@controller_action_param :password [String] The new password
    #@controller_action_param :password_confirmation [String] the new password confirmation
    #@return [Json] Json that contains wheter the account was created or not.
    #    If it is not successful, it returs an error message
    #@description Creates a new inactive account and sends a confirmation email so the
    #    new user can activate it
    #@example
    #    # Executing this controller's action from javascript's frontend
    #    let data = {
    #        user: {
    #            email: 'john.doe@email.com',
    #            password: 'my_password_1234567890',
    #            password_confirmation: 'my_password_1234567890'
    #        }
    #    };
    #    this.http.post('127.0.0.1/register', data);
    def create

        # Check if instance allow multi-account
        if !Rails.application.config.lesli.dig(:security, :allow_registration)
            respond_with_error(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
            return
        end

        # Validate user is unique
        if ::User.with_deleted.find_by(email: sign_up_params["email"])
            return respond_with_error(I18n.t("core.users/registrations.messages_info_user_already_exists"))
        end

        # build new user
        user = build_resource(sign_up_params)

        # run password complexity validations
        password_complexity = User::ValidationService.new(user).password_complexity(sign_up_params[:password])

        # return if there are errors with the complexity validations
        return respond_with_error("password_complexity_error", password_complexity.error) unless password_complexity.successful?

        # persist new user
        if user.save

            # save a default locale for user
            user.settings.create(:name => 'locale', :value => I18n.locale)

            respond_with_successful()

        else
            respond_with_error(user.errors.full_messages.to_sentence)
        end

    end

    # Self password update through the the profile/administration area
    def update

        log = @user.logs.create({ title: "password_update_atempt" })

        # run password complexity validations
        password_complexity = User::ValidationService.new(@user).password_complexity(sign_up_params[:password])

        # return if there are errors with the complexity validations
        return respond_with_error(password_complexity.error[0], password_complexity.error) unless password_complexity.successful?

        if @user.update(sign_up_params)

            # reset password expiration due the user just updated his password
            if @user.has_expired_password?
                @user.update(password_expiration_at: nil)
            end

            log.update(title: "password_update_successful")

            # Sign in the user by passing validation in case their password changed
            bypass_sign_in(@user)

            respond_with_successful

        else

            log.update(title: "password_update_error")

            respond_with_error(@user.errors.full_messages)

        end

    end

    def options
        respond_with_successful({
            countries: ::Account.first.locations.where(level: 'country').select(:name, :calling_code)
        })
    end


    protected


    #@return [void]
    #@description Configures the parameters allowed by devise using the devise method *sign_up_params*.
    #    This method is not called directly, it is called by devise.
    #@example
    #    # supose params contains {
    #    #    "user": {
    #    #        "email": "john.doe@email.com",
    #    #        "password": "my_password_12345",
    #    #        "password_confirmation": "my_password_12345"
    #    #        "name": "John Doe"
    #    #    }
    #    #}
    #    allowed_params = sign_up_params # devise will configure the params and made them available via this method
    #    puts allowed_params
    #    # will remove the name field and only print {
    #    #    "user": {
    #    #        "email": "john.doe@email.com",
    #    #        "password": "my_password_12345",
    #    #        "password_confirmation": "my_password_12345"
    #    #    }
    #    #}
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [
            :email, 
            :password, 
            :password_confirmation
        ])

    end

    def sign_up_params
        params.permit(:sign_up, 
            :email, 
            :password, 
            :password_confirmation,
            :first_name,
            :last_name,
            :telephone,
        )
    end

end
