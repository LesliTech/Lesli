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
class Template::AudienceDocument < ApplicationLesliRecord
    belongs_to :template,       foreign_key: "templates_id"
    belongs_to :user_creator,   foreign_key: "users_id",            class_name: "::User"
    belongs_to :file,           foreign_key: "account_files_id",    class_name:  "Account::File", optional: true

    def self.index current_user, query
        audience_documents = current_user.account.template.audience_documents.left_joins(:file).select(
            :id,
            :name,
            :created_at,
            :updated_at,
            :account_files_id
        )

        audience_documents = audience_documents.where("trim(lower(name)) like ?", "%#{query[:filters][:search].downcase}%") unless query[:filters][:search].blank?

        audience_documents = audience_documents
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

        LC::Response.pagination(
            audience_documents.current_page,
            audience_documents.total_pages,
            audience_documents.total_count,
            audience_documents.length,
            audience_documents.map do |audience_document|
                audience_document.attributes.merge({
                    created_at_text: LC::Date.to_string_datetime(audience_document.created_at)
                })
            end
        )
    end

    def self.list current_user, query
        audience_documents = current_user.account.template.audience_documents.select(
            :id,
            :name,
            :created_at,
            :updated_at
        )
    end

    def show(current_user, query)
        audience = current_user.account.template.audience_documents.select(
            :id,
            :name,
            :model_type,
            LC::Date.db_timestamps()
        ).find(id)
    end

    def self.options(current_user, query)
        if defined? DeutscheLeibrenten
            tables = DeutscheLeibrenten::TemplateAudienceDocumentOptionsService.new(current_user).tables
        end

        return {
            tables: tables
        }
    end
end
