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
    belongs_to :user,   foreign_key: "users_id",    class_name: "::User"

    validates :otp_secret, :presence => true
    validates :user, :presence => true

    # @return [void]
    # @description initialize secret code
    def self.initialize_secret_code(user)
        response = TokenAuthenticationService.create_otp_secret
        return nil unless response.success?
        self.create(otp_secret: response.payload[:otp_secret], user: user)
    end

    def self.index(current_user, query)
        []
    end

    def show(current_user, query)
        self
    end

    # @return [Integer]
    # @description generates an access code for the associated user
    def generate_code
        token_service = TokenAuthenticationService.new(self.user)
        response = token_service.create_token

        return nil unless response.success?
        return response.payload[:token].to_i
    end
end
