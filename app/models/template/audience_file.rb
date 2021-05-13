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
class Template::AudienceFile < ApplicationLesliRecord
    belongs_to :audience,       class_name: "Template::Audience",   foreign_key: "template_audiences_id"

    def self.index current_user, audience, query
        return audience.files.select(
            :id,
            :name,
            LC::Date.db_timestamps()
        )
    end

    def show(current_user, query)
        self
    end
end
