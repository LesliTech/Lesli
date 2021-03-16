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

require 'rotp'


class User::AccessCode < ApplicationLesliRecord
    before_create :generate_code

    belongs_to :user,   foreign_key: "users_id",    class_name: "::User"

    validates :user, :presence => true

    MIN_TOKEN_DURATION = 1*60

    def self.index(current_user, query)
        []
    end

    def show(current_user, query)
        self
    end

    # @return [Integer]
    # @description generates an access code for the associated user
    def generate_code
        _, enc = Devise.token_generator.generate(User, "id")
        self.token = enc
        self.expiration_at = Time.now.utc + MIN_TOKEN_DURATION
    end

    def register_use
        self.update(last_used_at: Time.now.utc)
        self.delete
    end

    def is_token_valid?
        now = Time.now.utc
        if  self.last_used_at.blank? and self.expiration_at > now
            return true
        end
        false
    end
end
