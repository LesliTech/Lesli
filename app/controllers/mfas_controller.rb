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
