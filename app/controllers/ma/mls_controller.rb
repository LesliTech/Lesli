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
class Ma::MlsController < ApplicationController
    include Application::Responder
    include Application::Logger

    before_action :set_user, only: [:index]

    # GET /ma/mls
    def index
        respond_to do |format|
            format.html {}
            format.json do
                if @user.present? and params[:token].present? and request.format.json?
                    return self.login
                end
                respond_with_error("invalid token")
            end
        end
    end

    private

    def set_user
        @user = User.find_by(id: params[:user_id], active: true)
    end

    def login
        session_validation = SessionValidationService.new(@user)
        response = session_validation.valid?

        unless response.success?
            return respond_with_error(response.error["message"])
        end

        token_auth_service = TokenAuthenticationService.new(@user)
        response = token_auth_service.is_token_valid?(params[:token])

        unless response.success?
            return respond_with_error(response.error[:details])
        end

        # do a user login
        sign_in @user


        # register a successful sign-in log for the current user
        @user.logs.create({ title: "session_creation_successful" })


        # register a new unique session
        @current_session = @user.sessions.create({
                                                         :user_agent => get_user_agent,
                                                         :user_remote => request.remote_ip,
                                                         :session_token => session[:session_id],
                                                         :session_source => "access_code_magic_link_session",
                                                         :last_used_at => LC::Date.now
                                                 })


        session[:user_session_id] = @current_session[:id]

        respond_with_successful
    end

    # Only allow a list of trusted parameters through.
    def ma_ml_params
        params.require(:ma_ml).permit(:token, :user_id)
    end
end
