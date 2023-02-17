=begin
Copyright (c) 2021, all rights reserved.

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
require "jwt"

class OauthService

    def self.apple_client_secret
        # Related documentation: https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens

        team_id = Rails.application.credentials.dig(:providers, :apple, :team_id)
        client_id = Rails.application.credentials.dig(:providers, :apple, :client_id)
        key_id = Rails.application.credentials.dig(:providers, :apple, :key_id)
        validity_period = Rails.application.credentials.dig(:providers, :apple, :validity_period) # In days. Max 180 (6 months) according to Apple docs.
        key = Rails.application.credentials.dig(:providers, :apple, :key)
        private_key = OpenSSL::PKey::EC.new(key)

        token = JWT.encode(
            {
                iss: team_id,
                iat: Time.now.to_i,
                exp: Time.now.to_i + 86400 * validity_period,
                aud: "https://appleid.apple.com",
                sub: client_id
            },
            private_key,
            "ES256",
            {
                kid: key_id 
            }
        )

        token

    end

end
