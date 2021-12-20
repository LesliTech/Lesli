=begin

Copyright (c) 2021, all rights reserved.

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
class Users::OauthController < Devise::OmniauthCallbacksController
    include Application::Responder
    include Application::Logger

    def google_oauth2

        auth_params = request.env['omniauth.auth']

        user = User.omniauth_registration(auth_params)

        unless user.persisted?
            return redirect_to(new_user_session_path)
        end

        # check if user meet requirements to login
        user_validation = UserValidationService.new(user).valid?

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
            :session_source => "devise_standar_session",
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

    def failure
        redirect_to("/login")
    end

end
