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
            @jwt_secret = Rails.application.credentials.dig(:services, :jwt, :secret)

            def self.encode(payload)
                
                # if no jwt key found in secret, use the rails key base as workaround
                # report to the user the missing key
                if @jwt_secret.blank?
                    Honeybadger.notify("JWT secret not found")
                    @jwt_secret = Rails.application.credentials.dig(:secret_key_base)
                end

                # if no secret found stop the process
                raise "JWT secret not found" if @jwt_secret.blank?
                
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
            rescue => error
                LC::Debug.msg error
                Honeybadger.notify(error)
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
