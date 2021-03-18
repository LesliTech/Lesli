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
class PassesController < ApplicationController
    include Application::Responder
    include Application::Logger

    before_action :set_user, only: [:create]

    # GET /passes
    def show

        # we use "t" as alias for token
        if params[:t].blank?

            redirect_to("/pass/new") and return

        end

        access_code = User::AccessCode.find_by(token: params[:t], token_type: "pass", last_used_at: nil)

        if access_code.blank?

            Account::Activity.log("core", "/pass", "pass_session_creation_failed", "not_valid_token_found", {
                token: (params[:t] || "")
            })

            redirect_to "/login", alert: "Not valid token found" and return

        end

        redirect_to "/login", alert: "Not valid token found" and return if !access_code.is_valid?

        # check if user meet requirements to login
        user_validation = UserValidationService.new(access_code.user).valid?

        # if user do not meet requirements to login
        redirect_to "/login", alert: "Not valid token found" and return unless user_validation.success?

        # do a user login
        sign_in(access_code.user)

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # register a successful sign-in log for the current user
        access_code.user.logs.create({ 
            title: "pass_session_creation_successful"
        })

        # register a new unique session
        @current_session = access_code.user.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_token => session[:session_id],
            :session_source => "pass_session",
            :last_used_at => Time.current
        })

        session[:user_session_id] = @current_session[:id]

        redirect_to "/"

    end


    # GET /passes/new
    def new
    end


    # POST /passes
    def create

        # check if is a valid user
        if @user.blank?
            respond_with_successful()
            return
        end

        # create a new pass
        pass = @user.access_codes.new({
            token_type: "pass"
        })

        if pass.save

            @user.logs.create({
                title: "pass_creation_successful",
                description: "user_agent: #{get_user_agent},user_remote: #{request.remote_ip}"
            })

            UserMailer.with(user: @user, token: pass.token).magic_link.deliver_now

            respond_with_successful()

        else
            respond_with_error(pass.errors.full_messages.to_sentence)
        end
        
    end

    private

    def set_user
        @user = User.find_by(email: params[:email], active: true)

        if @user.blank?
            Account::Activity.log("core", "pass", "pass_creation_failed", "no_valid_email", {
                email: (params[:email] || "")
            })
        end
    end

    # Only allow a list of trusted parameters through.
    def pass_params
        params.require(:pass).permit(:email)
    end
end
