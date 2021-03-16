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

    before_action :find_user, only: [:create]

    # GET /ma/mls
    def show
        if params[:token].blank?
            return render status: 200
        end

        access_token = User::AccessCode.find_by(token: params[:token])

        unless is_token_valid?(access_token)
            flash.alert = "The token has already been used"
            return render status: 200
        end

        self.login(access_token)
        redirect_to "/"

    end

    def create
        begin
            if @user.present?
                access_code = User::AccessCode.create(user: @user)
                send_email(access_code.token)
            end
        rescue
        end
        flash.notice = "An access mail was sent"
        redirect_to ma_ml_path
    end

    private

    def find_user
        @user = User.find_by(email: params[:user_email], active: true)

        if @user.blank?
            Account::Activity.log("core", "/ma/ml", "access_code_magic_link_session_creation_failed", "no_valid_email", {
                    email: (params[:user_email] || "")
            })
        end
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

    def login(access_token)

        # do a user login
        sign_in access_token.user
        access_token.register_use

        # register a successful sign-in log for the current user
        access_token.user.logs.create({ title: "access_code_magic_link_session_creation_successful", description: "token: #{access_token.token}" })

        # register a new unique session
        @current_session = access_token.user.sessions.create({
                                                         :user_agent => get_user_agent,
                                                         :user_remote => request.remote_ip,
                                                         :session_token => session[:session_id],
                                                         :session_source => "access_code_magic_link_session",
                                                         :last_used_at => LC::Date.now
                                                 })

        session[:user_session_id] = @current_session[:id]
    end

    def is_token_valid?(access_token)
        if access_token.blank?
            Account::Activity.log("core", "/ma/ml", "access_code_magic_link_session_creation_failed", "no_exist_token", {
                    token: (params[:token] || "")
            })
            return false
        end

        unless access_token.is_token_valid?
            access_token.user.logs.create({ title: "access_code_magic_link_session_creation_failed", description: "no_valid_token: #{access_token.token}" })
            return false
        end

        true
    end

    # Only allow a list of trusted parameters through.
    def ma_ml_params
        params.require(:ma_ml).permit(:token, :user_email)
    end
end
