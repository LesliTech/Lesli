=begin

Lesli

Copyright (c) 2020, all rights reserved.

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
require 'rotp'

##
# This class represents a One Time Password service for multiprosit such as 2FA, MagicLink, QuickLogin.

class TokenAuthenticationService
    ##
    # The resource must have the property otp_secret
    # @param [Object] resource
    def initialize(user)
        @user = user
        @resource = User::AccessCode.where(users_id: user.id).first
    end
    
    def self.create_otp_secret
        otp_secret = ROTP::Base32.random_base32
        LC::Response.service(true, {otp_secret: otp_secret})
    end

    def create_token
        unless @resource && @resource.otp_secret
            return LC::Response.service(false, {token: nil})
        end
        totp = ROTP::TOTP.new(@resource.otp_secret)
        LC::Response.service(true, { token: totp.now })
    end

    def is_token_valid?(token)
        return LC::Response.service(false, {details: "User is not configured to use access code"}) if @resource.nil?
        totp = ROTP::TOTP.new(@resource.otp_secret)
        last_otp_at = totp.verify(otp=token, drift_behind: 15, after:@resource.last_otp_at)

        unless last_otp_at
            return LC::Response.service(false, {details: "The token has already been used"})
        end
        @resource.update(last_otp_at: last_otp_at)
        LC::Response.service(true, {is_valid?: true})
    end
end
