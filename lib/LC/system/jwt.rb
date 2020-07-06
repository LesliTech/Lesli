=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module LC

    module System

        class Jwt

            def self.encode(payload, exp = 24.hours.from_now)
                payload[:exp] = exp.to_i
                JWT.encode(payload, Rails.application.credentials.services[:jwt][:secret])
            end

            def self.decode(token)
                {
                    valid: true,
                    data: JWT.decode(token, Rails.application.credentials.services[:jwt][:secret])
                }
            rescue JWT::ExpiredSignature
                {
                    valid: false,
                    error: "Not valid token found or token expired"
                }
            rescue
                {
                    valid: false,
                    error: "Not valid token found"
                }
            end

        end

    end

end
