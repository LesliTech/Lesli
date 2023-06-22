=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Users::OauthController < Devise::OmniauthCallbacksController

    # This is the callbacks controller. This controller will be handling the third-party redirects back to our application.
    # It is a Devise convention to create a controller method named as the authentication strategy, this means that there
    # will be a method for each authentication strategy.
    # Reference: https://www.digitalocean.com/community/tutorials/integrating-social-login-in-a-ruby-on-rails-application

    # Google callback
    def google_oauth2

        # The user data provided by the third-party is available in the request environment variable request.env['omniauth.auth'].
        omniauth_params = request.env['omniauth.auth']
        auth_params = {
            provider: omniauth_params.provider,
            uid: omniauth_params.uid,
            id_token: omniauth_params.extra.id_token,
            refresh_token: omniauth_params.credentials.refresh_token,
            access_token: omniauth_params.credentials.token,
            info: {
                email: omniauth_params.info.email,
                first_name: omniauth_params.info.first_name,
                last_name: omniauth_params.info.last_name,
            }
        }

        if @current_user
            synchronize(auth_params, "google_oauth2", @current_user)
        else
            authenticate(auth_params, "google_oauth2")
        end


    end

    # Facebook callback
    def facebook

        # The user data provided by the third-party is available in the request environment variable request.env['omniauth.auth'].
        omniauth_params = request.env['omniauth.auth']

        first_name, last_name = omniauth_params.extra.raw_info.name.split(" ") if omniauth_params.extra.raw_info.name

        auth_params = {
            provider: omniauth_params.provider,
            uid: omniauth_params.uid,
            info: {
                email: omniauth_params.info.email,
                first_name: first_name,
                last_name: last_name,
            }
        }

        authenticate(auth_params, "facebook")

    end

    def failure
        redirect_to("/login")
    end

    protected

    def authenticate(auth_params, session_source, current_user=nil)

        # find the user by email provided
        user = User::RegistrationService.new(
            User.find_by(email: auth_params[:info][:email])
        ).oauth(auth_params)

        unless user.persisted?
            return redirect_to(new_user_session_path)
        end

        # check if user meet requirements to login
        user_validation = User::ValidationService.new(user).valid?

        # if user do not meet requirements to login
        unless user_validation.success?
            return redirect_to(new_user_session_path)
        end

        sign_in(:user, user)

        # register or sync the user with the user representation on Firebase
        Courier::One::Firebase::User.sync_user(user) if defined? CloudOne

        # register a new unique session
        current_session = user.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_source => session_source,
            :last_used_at => LC::Date.now
        })

        # make session id globally available
        session[:user_session_id] = current_session[:id]

        # register a successful sign-in log for the current user
        user.logs.create({ user_sessions_id: session[:user_session_id], title: "session_creation_successful" })

        default_path = user.roles.first&.default_path

        if user.account&.onboarding? && user.has_roles?("owner")
            default_path = "/onboarding"
        end

        return redirect_to(default_path) if default_path

        redirect_to("/dashboard")

    end

    def synchronize(auth_params, session_sourc, user)
        auth_provider = auth_params[:provider]
        auth_provider = "Google" if auth_params[:provider] == "google_oauth2"

        if user
            # set a new provider for and existent user
            user.auth_providers.find_or_create_by({
                provider: auth_provider,
                uid: auth_params[:uid],
                id_token: auth_params[:id_token],
                access_token: auth_params[:access_token],
                refresh_token: auth_params[:refresh_token],
            })

            return redirect_to(new_user_session_path)
        end

        # find the user by provided uid
        user_auth_provider = User::AuthProvider.find_by({
            provider: auth_provider,
            uid: auth_params[:uid],
        })

        user = user_auth_provider.user if user_auth_provider

        return redirect_to(new_user_session_path)
    end

end
