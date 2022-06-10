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
    def has_mfa_enabled?
        is_enabled = @resource.settings.find_by(:name => "mfa_enabled", :value => "t")
        has_any_method_confifured = @resource.settings.find_by(:name => "mfa_method")

        return LC::Response.service(true) if is_enabled && has_any_method_confifured
        
        LC::Response.service(false)
    end

    ## The key is the email encrypted, we replace any whitespace by the "+" sign
    ## Because the param that comes from the URL (fronted) has whitespace instead of "+"
    def self.parse_key key
        return key.gsub(/[[:space:]]/, '+')
    end

    def self.encrypt_key key
        EncryptorService.new_encrytor.encrypt_and_sign(key)
    end

    def self.decrypt_key key
        begin
            return LC::Response.service(true, EncryptorService.new_encrytor.decrypt_and_verify(key))
        rescue => exception
            puts LC::Debug.deprecation(exception)
            return LC::Response.service(false, I18n.t("core.users/sessions.messages_danger_invalid_url_key_param"))
        end
    end

    ######## Do MFA respective actions ########
    def do_mfa request
        # Get the MFA method the user has configured
        method = @resource.mfa_method

        # Depending on the case, we send the MFA Code to different destinies (email, sms, ... )
        case method
        when "email" # Enum: E-mail
            mfa_token_sent = send_mfa_token_via_email(request)

            # Respond with error if the MFA code was not sent for some reason
            return LC::Response.service(false, code_sent.error) unless mfa_token_sent.successful?
        else
            # Respond with error if something is wrong with the user's MFA method configured
            return LC::Response.service(false, I18n.t("core.users/sessions.messages_danger_not_valid_mfa_method"))
        end

        # Encrypt the email to send it in the request as a query, like ?key=THE_ENCRYPTED_EMAIL
        encrypted_email = MfaService.encrypt_key(@resource.email)


        return LC::Response.service(true, { default_path: "/mfa/enter_code?key=#{encrypted_email}" }) # "key" is the encrypted email
    end

    private

    ######## Ways to send MFA code ########

    # In the case we will implement other factors to authenticate the user (Google Authenticator, push notifications, ..)
    # They should be configured in this service

    ## Send the email with the MFA Token and log its creation
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
end
