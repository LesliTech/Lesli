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
    include Interfaces::Application::Responder
    include Interfaces::Application::Requester
    include Interfaces::Application::Logger

    before_action :set_user, only: [:create]

    # GET /passes
    def show

        # we use "t" as alias for token
        return if params[:t].blank?

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

        log = access_code.user.logs.create({ title: "session_creation_atempt"})

        # denied access if token do not meet validations
        unless access_code.is_valid?
            log.update(title: "session_creation_failed", description: error_msg)
            redirect_to(new_user_session_path, alert: error_msg) and return if !access_code.is_valid?
        end

        # cache the user from the access code
        resource = access_code.user

        # check if user meet requirements to create a new session
        Auth::UserValidationService.new(access_code.user).valid? do |result|
            # if user do not meet requirements to create a new session
            unless result.success?
                log.update(title: "session_creation_failed", description: error_msg)
                redirect_to(new_user_session_path, alert: error_msg) and return unless result.success?
            end
        end

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # do a user login
        sign_in(access_code.user)

        # after session is created
        Auth::UserSessionService.new(resource, log).create(get_user_agent, request.remote_ip, "pass_web_session") do |result|

            # make session id globally available
            session[:user_session_id] = result[:user_sessions_id]

            # respond successful and send the path user should go
            redirect_to(result[:default_path]) and return 

        end

        # redirect to the root path and return 
        redirect_to("/") and return 

    end

    # POST /passes
    def create

        # check if is a valid user
        return respond_with_successful() if @user.blank?

        # create a new pass
        pass = @user.access_codes.new({ token_type: "pass" })

        # generate a user-friendly token
        raw, enc = Devise.token_generator.create(pass.class, :token, length:25)

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
