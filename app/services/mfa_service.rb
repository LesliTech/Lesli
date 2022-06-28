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


######## This service is used for any MFA case ########

class MfaService
    def initialize resource
        @resource = resource
    end

    # @return [Boolean]
    # @description Verify if the resource (user) has MFA enabled and one MFA method (email, ...) configured
    # @example
    #   user_mfa = MfaService.new(my_user)
    #   puts user_mfa.has_mfa_enabled?.success?
    #       true/false
    def has_mfa_enabled?
        resource_mfa_settings = @resource.mfa_settings

        return LC::Response.service(true) if resource_mfa_settings[:enabled] && mfa_methods.include?(resource_mfa_settings[:method])
        
        LC::Response.service(false)
    end

    # @return [Service response (true/false + payload/error)]
    # @param request [HTTP Request] the request that is present in the controller when a user does a request
    # @description 
    #       This method basically sends the MFA token to the respective method (email, ...) configured by the user
    # @example
    #   user_mfa = MfaService.new(my_user)
    #   send_mfa_token = user_mfa.do_mfa(request) # the request that is present in the controller action
    #
    #   # If success
    #   puts send_mfa_token.success?
    #       true
    #   # If is something went wrong 
    #   puts send_mfa_token.success?
    #       false
    #   puts send_mfa_token.error?
    #       "An error message"
    def do_mfa
        # Get the MFA method the user has configured
        method = @resource.settings.find_by(:name => "mfa_method")

        # Depending on the case, we send the MFA Code to different destinies (email, sms, ... )
        case method.value
        when mfa_methods[:email] # Enum: E-mail
            mfa_token_sent = send_mfa_token_via_email()

            # Respond with error if the MFA code was not sent for some reason
            return LC::Response.service(false, mfa_token_sent.error) unless mfa_token_sent.success?
        else
            # Respond with error if something is wrong with the user's MFA method configured
            return LC::Response.service(false, I18n.t("core.users/sessions.messages_danger_not_valid_mfa_method"))
        end

        return LC::Response.service(true)
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

    # @return [Hash]
    # @description Returns the MFA methods specified in the lesli.yml (email, ...)
    # @example
    #   puts mfa_methods
    #       { email: "email" }
    def mfa_methods
        Rails.application.config.lesli.dig(:configuration, :mfa_methods)
    end
end
