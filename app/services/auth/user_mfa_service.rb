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

module Auth
    class UserMfaService

        def initialize(resource)
            @resource = resource
            @resource_mfa_settings = @resource.mfa_settings
        end

        def is_enabled?

            account_mfa_methods = Rails.application.config.lesli.dig(:configuration, :mfa_methods)

            return @resource_mfa_settings[:enabled] && account_mfa_methods.include?(@resource_mfa_settings[:method])
            
        end

        def generate

            # Get the MFA method the user has configured
            mfa_method = @resource_mfa_settings.dig(:method)

            # Depending on the case, we send the MFA Code to different destinies (email, sms, etc.)
            case mfa_method
            when :email
                send_mfa_token_via_email()
            end

            yield(:mfa_method => mfa_method)

        end

        private

        # @return [Service response (true/false + payload/error)]
        # @description Send the email with the MFA Token and log its creation
        # @example
        #   mfa_token_sent = send_mfa_token_via_email()
        def send_mfa_token_via_email

            # We use a reusable service that generates access codes
            access_code = @resource.access_codes.new({ :token_type => "mfa" })
    
            # We generate the raw and the encrypted token
            raw, enc = Devise.token_generator.create(access_code.class, :token, type:'number', length:6)
    
            # Set the encrypted token, which will be saved into the DB
            access_code.update(token: enc)
    
            UserMailer.with(user: @resource, token: raw).mfa_instructions.deliver_now

        end

    end
end
