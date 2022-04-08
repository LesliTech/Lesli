=begin
Copyright (c) 2022, all rights reserved.

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
class Account::Crono::Log < ApplicationLesliRecord
    belongs_to :crono,      foreign_key: "account_cronos_id"

    def self.index(current_user, query, crono)
        crono.logs.map do |log|
            log_attributes = log.attributes
            log_attributes["created_at_string"] = LC::Date.to_string_datetime(log_attributes["created_at"])

            log_attributes
        end
    end

    def show(current_user, query)
        self
    end
end
