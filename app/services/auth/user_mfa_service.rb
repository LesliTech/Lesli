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
        end

        def is_enabled?

            return true

            resource_mfa_settings = @resource.mfa_settings

            return if resource_mfa_settings[:enabled] && mfa_methods.include?(resource_mfa_settings[:method])
            
        end

        def execute

            mfa_settings = @resource.mfa_settings
            LC::Debug.msg mfa_settings
            yield()

            return 

            result = LC::Response.service(true)

            

            mfa_methods = Rails.application.config.lesli.dig(:configuration, :mfa_methods)
        
            # Get the MFA method the user has configured
            mfa_method = @resource.settings.find_by(:name => "mfa_method")

            LC::Debug.msg mfa_method

            # Depending on the case, we send the MFA Code to different destinies (email, sms, ... )
            case mfa_method
            when mfa_methods[:email]
                mfa_token_sent = send_mfa_token_via_email()
            end

            

        end

        private

        # @return [Service response (true/false + payload/error)]
        # @description Send the email with the MFA Token and log its creation
        # @example
        #   mfa_token_sent = send_mfa_token_via_email()
        def send_mfa_token_via_email
            # We use a reusable service that generates access codes
            user_mfa_access_code = @resource.access_codes.new({ :token_type => "mfa" })
    
            # We generate the raw and the encrypted token
            raw, enc = Devise.token_generator.generate_token(user_mfa_access_code.class, :token, 2, true)
    
            # Set the encrypted token, which will be saved into the DB
            user_mfa_access_code.token = enc
    
            if user_mfa_access_code.save
                # Send E-mail with the MFA Token
                UserMailer.with(user: @resource, token: raw).mfa_instructions.deliver_now unless Rails.env.test?
    
                return LC::Response.service(true)
            else
                return LC::Response.service(false, user_mfa_access_code.errors.full_messages.to_sentence)
            end
        end

    end
end
