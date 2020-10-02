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

class Account::Integration < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"

    after_create :build_access_uuid
    after_create :build_access_token

    def build_access_uuid

        rebuild_uuid = true

        while rebuild_uuid do

            access_uuid = SecureRandom.uuid

            # assign token to user if token is unique
            if not Account::Integration.find_by(:access_uuid => access_uuid)
                self.access_uuid = access_uuid
                self.save!
                rebuild_uuid = false
            end

        end

    end

    def build_access_token

        rebuild = true

        while rebuild do

            access_token = SecureRandom.alphanumeric(16)

            # assign token to user if token is unique
            if not Account::Integration.find_by(:access_token => access_token)
                self.access_token = access_token
                self.save!
                rebuild = false
            end

        end

    end

end
