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

    before_action :set_user, only: [:show]
    before_action :find_user, only: [:create]

    # GET /ma/mls
    def show
        unless params[:token].present?
            return render status: 200
        end

        unless is_session_valid? and is_token_valid?
            flash.alert = "The token has already been used"
            return render status: 200
        end

        self.login
        redirect_to "/"

    end

    def create
        begin
            if @user.present?
                token = User::AccessCode.find_by(user: @user).generate_code
                send_email(token)
            end
        rescue
        end
        flash.notice = "An access mail was sent"
        redirect_to ma_ml_path
    end

    private

    def set_user
        @user = User.find_by(id: params[:user_id], active: true)
    end

    def find_user
        @user = User.find_by(email: params[:user_email], active: true)
    end

    def send_email(token)
        @user.logs.create(
                {
                        title: "access_code_magic_link_request",
                        description: "user_agent: #{get_user_agent},user_remote: #{request.remote_ip}"
                }
        )
        UserMailer.with(user: @user, token: token).magic_link.deliver_now
    end

    def login

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
    end

    def is_session_valid?
        unless  @user.present?
            return false
        end

        session_validation = SessionValidationService.new(@user)
        response = session_validation.valid?

        unless response.success?
            return false
        end

        true
    end

    def is_token_valid?
        unless params[:token].present?
            return false
        end

        token_auth_service = TokenAuthenticationService.new(@user)
        response = token_auth_service.is_token_valid?(params[:token])

        unless response.success?
            return false
        end

        true
    end

    # Only allow a list of trusted parameters through.
    def ma_ml_params
        params.require(:ma_ml).permit(:token, :user_id, :user_email)
    end
end
