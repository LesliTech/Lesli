=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   ldonis & Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Manages registrations for new users

=end
class Users::RegistrationsController < Devise::RegistrationsController
    layout "application-public"
    
    before_action :configure_sign_up_params, only: [:create]


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
        
        # build new user
        user = build_resource(sign_up_params)

        # persist new user
        if user.save

            # create new account for the new user
            account = Account.create({
                company_name: user.email,
                status: 0,
                user: user
            })

            # add user to his own account
            user.account = account

            # set user as owner of his just created account
            user.role = account.roles.joins(:detail).where("role_details.name = 'owner'").first

            # update user :)
            user.save

            # initialize user with necessary data to work with the platform
            user.initialize_user

            # response successfully
            responseWithSuccessful

        else
            responseWithError(user.errors.full_messages.to_sentence)
        end
        
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
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    end
    
end
