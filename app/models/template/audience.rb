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
class Template::Audience < ApplicationLesliRecord
    def self.index current_user, query
        audiences = current_user.account.template.audiences.select(
            :id,
            :name,
            :created_at,
            :updated_at
        )

        audiences = audiences.where("trim(lower(name)) like ?", "%#{query[:filters][:search].downcase}%") unless query[:filters][:search].blank?

        audiences = audiences
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

        LC::Response.pagination(
            audiences.current_page,
            audiences.total_pages,
            audiences.total_count,
            audiences.length,
            audiences.map do |audience|
                audience.attributes.merge({
                    created_at_text: LC::Date.to_string_datetime(audience.created_at)
                })
            end
        )
    end

    def self.list current_user, query
        audiences = current_user.account.template.audiences.select(
            :id,
            :name,
            :created_at,
            :updated_at
        )
    end

    def self.show(current_user, id)
        audience = current_user.account.template.audiences.select(
            :id,
            :name,
            :model_type,
            LC::Date.db_timestamps()
        ).find(id)
    end
end
