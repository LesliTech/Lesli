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
class Account::PrivilegeGroup < ApplicationLesliRecord
    has_many :actions,    foreign_key: "account_privilege_groups_id"
    
    def self.index(current_user, query)
        belongs_to :user_creator,   foreign_key: "users_id",            class_name: "::User"
        belongs_to :account,        foreign_key: "accounts_id",         class_name: "Account"  
        
        role_groups = current_user.account.privilege_groups.select(
            :id,
            :name,
            :description,
            :created_at,
        )
        .joins(:user_creator)

        role_groups = role_groups.where("
            trim(lower(account_role_groups.name)) like '%#{query[:filters][:search].downcase}%' or  
            trim(lower(account_role_groups.description)) like '%#{query[:filters][:search].downcase}%'
        ") unless query[:filters][:search].blank?

        role_groups = role_groups
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

        LC::Response.pagination(
            role_groups.current_page,
            role_groups.total_pages,
            role_groups.total_count,
            role_groups.length,
            role_groups.map do |audience_document|
                audience_document.attributes.merge({
                    created_at_text: LC::Date.to_string_datetime(audience_document.created_at)
                })
            end
        )
    end

    def show(current_user, query)
        audience = current_user.account.privilege_groups.select(
            :id,
            :name,
            :description
            LC::Date.db_timestamps()
        ).find(id)
    end
end
