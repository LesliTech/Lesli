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
class RoleDescriptor < ApplicationLesliRecord
    has_many :privilege_actions,          foreign_key: "role_descriptors_id", class_name: "RoleDescriptor::PrivilegeAction"  
    
    belongs_to :user_creator,   foreign_key: "users_id",            class_name: "::User",   optional: true
    belongs_to :account,        foreign_key: "accounts_id",         class_name: "Account"  
    
    def self.index(current_user, query)
        role_descriptors = current_user.account.role_descriptors.select(
            :id,
            :name,
            :description,
            :created_at,
            "actions.total as actions_length"
        )
        .left_joins(:user_creator)
        .joins("
            left join  (
                select 
                    count(1) as total,
                    apga.role_descriptors_id as role_descriptor_id
                from role_descriptor_privilege_actions apga
                where apga.status = TRUE
                group by apga.role_descriptors_id
            ) as actions 
                on actions.role_descriptor_id = role_descriptors.id
        ")
        .where.not("role_descriptors.name = ? or role_descriptors.name = ?", "admin", "owner")

        role_descriptors = role_descriptors.where("
            trim(lower(role_descriptors.name)) like '%#{query[:filters][:search].downcase}%' or  
            trim(lower(role_descriptors.description)) like '%#{query[:filters][:search].downcase}%'
        ") unless query[:filters][:search].blank?

        role_descriptors = role_descriptors
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

        LC::Response.pagination(
            role_descriptors.current_page,
            role_descriptors.total_pages,
            role_descriptors.total_count,
            role_descriptors.length,
            role_descriptors.map do |role_descriptor|
                role_descriptor.attributes.merge({
                    created_at_text: LC::Date.to_string_datetime(role_descriptor.created_at),
                    actions_length:  role_descriptor.actions_length ? role_descriptor.actions_length : 0
                })
            end
        )
    end

    def self.list(current_user, query)
        role_descriptors = current_user.account.role_descriptors.select(
            :id,
            :name,
            :description,
            :created_at,
            :role_descriptors_id
        )
        
        return role_descriptors
    end
    
    def show(current_user, query)
        current_user.account.role_descriptors.select(
            :id,
            :name,
            :description,
            LC::Date.db_timestamps()
        ).find(id)
    end
end
