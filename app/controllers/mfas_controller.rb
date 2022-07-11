=begin

Copyright (c) 2022, all rights reserved.

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


class MfasController < ApplicationController
    include Interfaces::Application::Responder
    include Interfaces::Application::Requester
    include Interfaces::Application::Logger

    def update

        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")

        # rebuild the token based on the user-token sent by email
        digest_token = Devise.token_generator.digest(User::AccessCode, :token, mfa_params[:t])

        # denied access if can't build the token
        return respond_with_unauthorized(error_msg) if digest_token.blank?

        # search for the requested pass
        access_code = User::AccessCode.find_by(token: digest_token, token_type: "mfa", last_used_at: nil)

        # denied access if can't build the token
        return respond_with_unauthorized(error_msg) if access_code.blank?

        log = access_code.user.logs.create({ title: "session_creation_atempt" })

        # check if the access code is valid
        unless access_code.is_valid?

            # save a invalid credentials log for the requested user
            log.update(title: "session_creation_failed", description: error_msg)

            # denied access if token not found
            return respond_with_unauthorized(error_msg) 

        end

        # cache the user from the access code
        resource = access_code.user

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # do a user login
        sign_in(:user, resource)

        respond_with_successful({default_path:"/"})

    end

    private

    # Only allow a list of trusted parameters through.
    def mfa_params
        params.fetch(:mfa, {}).permit(
            :t # the MFA token
        )
    end
end
