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



########    This service is reusable, mostly used to create and/or verify codes for the UserAccessCodes entify

class AccessCodeService

    # @return [hash]
    # @param user [::User] The user that is requesting another way to login
    # @param token_type [String] The token type will be saved (otp, pass, ...)
    # @description Creates a new Access Code and returns the one created & the raw token
    # @example
    #   otp = AccessCodeService.create_access_code(@user, "otp")
    
    #   puts otp.successful? # true/false
    #   puts otp.access_code # Instance of User::AccessCode
    #   puts otp.raw         # code if success

    def self.create_access_code user, token_type
        token_type = token_type.downcase

        # Instance a new access_code according with token_type param was sent
        access_code = user.access_codes.new( { token_type: token_type } )

        # Generate a token with Devise
        # raw: a compressed version of the token
        # enc: the encrypted token (lots of letters, numbers and signs so not understandable by users)
        if token_type.eql? "otp"
            raw, enc = Devise.token_generator.generate_otp(access_code.class, :token)
        else
            raw, enc = Devise.token_generator.generate(access_code.class, :token)
        end

        # Set the token for the encrypted one created by Devise
        access_code.token = enc

        # Try to saved into the DB
        if access_code.save
            return LC::Response.service(true, { :access_code => access_code, :raw => raw }) 
        else
            return LC::Response.service(false, access_code.errors.full_messages.to_sentence)
        end
    end


    # @return [hash]
    # @param token [String] Token the user has sent
    # @param token_type [String] The token type will be verified (otp, pass, ...)
    # @param user [::User] The user that is requesting to validate the token
    # @description Validates the token the user has sent through params
    # @example
    #   otp = AccessCodeService.verify_access_code("123AAER", "otp", user)
    
    #   puts otp.successful? # true/false
    #   puts otp.payload # Instance of User::AccessCode if success
    #   puts otp.error   # If something went wrong

    def self.verify_access_code token, token_type, user = nil
        # Rebuild the token based on the user-token sent by email
        digest_token = Devise.token_generator.digest(User::AccessCode, :token, token)
        # Return nil if could not build the token
        return LC::Response.service(false, :digest_token) if digest_token.blank?

        # Find access code for the requested token
        access_code = user.nil? ? User::AccessCode.find_by(token: digest_token, token_type: token_type, last_used_at: nil) 
                                    : user.access_codes.find_by(token: digest_token, token_type: token_type, last_used_at: nil) 

        if access_code.blank?
            Account::Activity.log("core", "/mfa/enter_code", "mfa_token_session_verification_failed", "not_valid_token_found", {
                token: (token || "")
            })

            # Return false if the token was not found
            return LC::Response.service(false, :access_code)
        end
        
        # Denied access if token do not meet validations
        return LC::Response.service(false, :invalid_access_code) if !access_code.is_valid?

        # Delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # Return true if all validations were successful
        return LC::Response.service(true)
    end
end
