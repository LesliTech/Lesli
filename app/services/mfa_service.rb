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

    ## Initialize the resource (user)
    def initialize resource
        @resource = resource
    end

    ## Verify if the resource (user) has MFA enabled and one MFA method (email, ...) configured
    # @return [Boolean]
    # @description Verify if the resource (user) has MFA enabled and one MFA method (email, ...) configured
    # @example
    #   user_mfa = MfaService.new(my_user)
    #   puts user_mfa.has_mfa_enabled?.success?
    #       true/false
    def has_mfa_enabled?
        is_enabled = @resource.settings.find_by(:name => "mfa_enabled", :value_boolean => true)
        has_any_method_confifured = @resource.settings.find_by(:name => "mfa_method")

        return LC::Response.service(true) if is_enabled && has_any_method_confifured
        
        LC::Response.service(false)
    end

    # @return [Encrypted String]
    # @param key [String] any string (we call it "key") you want to encrypt
    # @description This method returns an encrypted "key", which is given through arguments
    # @example
    #   encrypted_key = MfaService.encrypt_key("test")
    #   puts encrypted_key
    #       "FhIIEK0hToXLVJN+915bsQhAOUq/9IKR0jxyL90H4EHiFQVxmxur/Hqw--xWOQdECZ9c7kO8UN--AiytpQe1ZpS58tygZPQVZA=="
    def self.encrypt_key key
        EncryptorService.new_encrytor.encrypt_and_sign(key)
    end

    # @return [Decrypted String]
    # @param key [String] any string (we call it "key") you want to decrypt
    # @description This method returns a decrypted "key", which is given through arguments
    # @example
    #   encrypted_key = MfaService.decrypt_key("FhIIEK0hToXLVJN+915bsQhAOUq/9IKR0jxyL90H4EHiFQVxmxur/Hqw--xWOQdECZ9c7kO8UN--AiytpQe1ZpS58tygZPQVZA==")
    #   puts encrypted_key
    #       "test@lesli.cloud"
    def self.decrypt_key key
        begin
            return LC::Response.service(true, EncryptorService.new_encrytor.decrypt_and_verify(key))
        rescue => exception
            puts LC::Debug.deprecation(exception)
            return LC::Response.service(false)
        end
    end

    ######## Do MFA respective actions ########

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
    #   puts send_mfa_token.payload?
    #       {  }
    #
    #   # If success
    #   puts send_mfa_token.success?
    #       false
    #   puts send_mfa_token.error?
    #       "An error message"
    def do_mfa request
        # Get the MFA method the user has configured
        method = @resource.settings.find_by(:name => "mfa_method")

        # Depending on the case, we send the MFA Code to different destinies (email, sms, ... )
        case method.value
        when mfa_methods[:email] # Enum: E-mail
            mfa_token_sent = send_mfa_token_via_email(request)

            # Respond with error if the MFA code was not sent for some reason
            return LC::Response.service(false, mfa_token_sent.error) unless mfa_token_sent.success?
        else
            # Respond with error if something is wrong with the user's MFA method configured
            return LC::Response.service(false, I18n.t("core.users/sessions.messages_danger_not_valid_mfa_method"))
        end

        # Encrypt the email to send it in the request as a query, like ?key=THE_ENCRYPTED_EMAIL
        encrypted_email = CGI.escape(MfaService.encrypt_key(@resource.email))

        return LC::Response.service(true, { default_path: "/mfa/new?key=#{encrypted_email}" }) # "key" is the encrypted email
    end

    private

    ######## Ways to send MFA code ########

    # In the case we will implement other factors to authenticate the user (Google Authenticator, push notifications, ..)
    # They should be configured in this service

    # @return [Service response (true/false + payload/error)]
    # @param request [HTTP Request] the request that is present in the controller when a user does a request 
    #       this methods is used by the do_mfa() method in this service
    # @description Send the email with the MFA Token and log its creation
    # @example
    #   mfa_token_sent = send_mfa_token_via_email(request)
    def send_mfa_token_via_email request
        # We use a reusable service that generates access codes
        user_mfa_access_code = @resource.access_codes.new({ :token_type => "mfa" })

        # We generate the raw and the encrypted token
        raw, enc = Devise.token_generator.generate_token(user_mfa_access_code.class, :token, 2, true)

        # Set the encrypted token, which will be saved into the DB
        user_mfa_access_code.token = enc

        if user_mfa_access_code.save
            # Create logs that an MFA Token was created successfully
            @resource.logs.create({
                title: "mfa_token_creation_successful",
                description: "user_agent: #{request.user_agent}, user_remote: #{request.remote_ip}"
            })

            # Send E-mail with the MFA Token
            UserMailer.with(user: @resource, token: raw).mfa_instructions.deliver_now

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
