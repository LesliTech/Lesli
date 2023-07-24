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


class User::MfaService

    def initialize(resource, log)
        @log = log
        @resource = resource
        @resource_mfa_settings = @resource.mfa_settings
    end

    # check if user has enable multi-factor authentication
    # or if the account has enable mfa for all the users
    # NOTE: User also needs to have a MFA method selected
    def is_enabled?

        # get the available MFA methods
        account_mfa_methods = Rails.application.config.lesli.dig(:configuration, :mfa_methods)

        # TODO: Check for the account settings for global MFA

        # return if user has MFA enabled with a valid method
        return @resource_mfa_settings[:enabled] && account_mfa_methods.include?(@resource_mfa_settings[:method])
    end

    # Generate a MFA code
    def generate

        # return with false if MFA is not enabled
        return yield(false) unless is_enabled?()

        # update the log of the login to indicate user needs a second step to login
        @log.update(description: "session_mfa_enabled")

        # Get the MFA method the user has configured
        mfa_method = @resource_mfa_settings.dig(:method)

        # Depending on the case, we send the MFA Code to different destinies (email, sms, etc.)
        case mfa_method
        when :email
            send_mfa_token_via_email()
        end

        # update the log of the login to indicate that a MFA code was sent to the user
        @log.update(description: "session_mfa_sent via: #{ mfa_method }")

        yield(true)

    end

    private

    def access_code 

        # We use a reusable service that generates access codes
        access_code = @resource.access_codes.new({ :token_type => "mfa" })

        # We generate the raw and the encrypted token
        raw, enc = Devise.token_generator.create(access_code.class, :token, type:'number', length:6)

        # Set the encrypted token, which will be saved into the DB
        access_code.update(token: enc)

        raw
        
    end

    # @return [Service response (true/false + payload/error)]
    # @description Send the email with the MFA Token and log its creation
    # @example
    #   mfa_token_sent = send_mfa_token_via_email()
    def send_mfa_token_via_email
        raw_access_code = access_code()
        UserMailer.with(user: @resource, token: raw_access_code).mfa_instructions.deliver_now
    end

end
