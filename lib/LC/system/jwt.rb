=begin

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

module LC

    module System

        class Jwt

            @algorithm = "HS512"
            @jwt_secret = Rails.application.credentials.services[:jwt][:secret]

            def self.encode(payload)
                payload[:exp] = 24.hours.from_now if payload[:exp].blank?
                payload[:exp] = payload[:exp].to_i
                payload[:iat] = Time.now.to_i
                token = JWT.encode(
                    payload,                # data to encode
                    @jwt_secret,            # super secret key
                    algorithm = @algorithm, # algorithm
                    header_fields = {       # custom headers
                        typ: "JWT"
                    }
                )
                LC::Response.service(true, token)
            end

            def self.decode(token)
                LC::Response.service(true, JWT.decode(token, @jwt_secret, true, { 
                    algorithm: @algorithm
                }))
            rescue JWT::ExpiredSignature
                LC::Response.service(false, I18n.t("core.shared.messages_danger_not_valid_token_found_or_token_expired"))
            rescue
                LC::Response.service(false, I18n.t("core.shared.messages_danger_not_valid_token_found"))
            end

        end

    end

end
