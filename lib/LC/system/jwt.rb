=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module LC

    module System

        class Jwt

            @algorithm = "HS512"
            @jwt_secret = Rails.application.credentials.dig(:services, :jwt, :secret)

            # if no jwt key found in secret, use the rails key base as workaround
            # report to the user the missing key
            if @jwt_secret.blank?
                Honeybadger.notify("JWT secret not found")
                @jwt_secret = Rails.application.credentials.dig(:secret_key_base)
            end

            def self.encode(payload)

                # if no secret found stop the process
                #raise "JWT secret not found" if @jwt_secret.blank?
                
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
