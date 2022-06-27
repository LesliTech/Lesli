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
        redirect_to("/pass/new") and return if params[:t].blank?

        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")

        # rebuild the token based on the user-token sent by email
        digest_token = Devise.token_generator.digest(User::AccessCode, :token, params[:t])

        # denied access if can't build the token
        redirect_to(new_user_session_path, alert: error_msg) and return if digest_token.blank?

        # search for the requested pass
        access_code = User::AccessCode.find_by(token: digest_token, token_type: "pass", last_used_at: nil)

        # denied access if token not found
        if access_code.blank?

            Account::Activity.log("core", "/pass", "pass_session_creation_failed", "not_valid_token_found", {
                token: (params[:t] || "")
            })

            redirect_to(new_user_session_path, alert: error_msg) and return

        end

        # denied access if token do not meet validations
        redirect_to(new_user_session_path, alert: error_msg) and return if !access_code.is_valid?

        # check if user meet requirements to login
        user_validation = UserValidationService.new(access_code.user).valid?

        # check if user meet requirements to create a new session
        Auth::UserValidationService.new(access_code.user).valid? do |result|
            # if user do not meet requirements to create a new session
            redirect_to(new_user_session_path, alert: error_msg) and return unless result.success?
        end

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # do a user login
        sign_in(access_code.user)

        # register a new unique session
        current_session = access_code.user.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_token => session[:session_id],
            :session_source => "pass_session",
            :last_used_at => Time.current
        })

        # make session id globally available
        session[:user_session_id] = current_session[:id]

        # after session is created
        Auth::UserSessionService.new(access_code.user).after_create(current_session) do |result|

            default_path = result[:default_path]

            # if first loggin for account owner send him to the onboarding page
            if current_user.account.onboarding? && current_user.has_roles?("owner")
                default_path = "/onboarding"
            end

            # respond successful and send the path user should go
            redirect_to(default_path) and return 

        end


        # redirect to the root path and return 
        redirect_to("/") and return 

    end


    # GET /passes/new
    def new
    end


    # POST /passes
    def create

        # check if is a valid user
        return respond_with_successful() if @user.blank?

        # create a new pass
        pass = @user.access_codes.new({ token_type: "pass" })

        # generate a user-friendly token
        raw, enc = Devise.token_generator.generate(pass.class, :token)

        # save encrypted token in database
        pass.token = enc

        # try to save the access code
        if pass.save

            @user.logs.create({
                title: "pass_creation_successful",
                description: "#{request.remote_ip} | #{get_user_agent}"
            })

            UserMailer.with(user: @user, token: raw).pass_instructions.deliver_now

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
