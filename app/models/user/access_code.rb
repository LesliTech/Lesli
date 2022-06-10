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

class User::AccessCode < ApplicationLesliRecord

    before_create :generate_token

    belongs_to :user, foreign_key: "users_id", class_name: "::User"

    validates :user, :presence => true

    enum token_type: { pass: "pass", otp: "otp", mfa: "mfa" }

    MIN_TOKEN_DURATION = 4 * 60


    # @return [Integer]
    # @description generates an access code for the associated user
    def generate_token

        # set an expiration time
        self.expiration_at = Time.now.utc + MIN_TOKEN_DURATION

    end


    # @return [Boolean]
    # @description Check if token meets requirements to be used as authentication method
    def is_valid?

        if !self.last_used_at.blank? 

            self.user.logs.create({ 
                title: "pass_session_creation_failed", 
                description: "token_used_already" 
            })

            return false

        end

        if self.expiration_at < Time.now.utc

            self.user.logs.create({ 
                title: "pass_session_creation_failed", 
                description: "token_expired" 
            })

            self.delete

            return false

        end

        return true

    end

end
