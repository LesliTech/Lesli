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
    has_many :actions,    foreign_key: "account_privilege_groups_id", class_name: "Account::PrivilegeGroupAction"  
    
    belongs_to :user_creator,   foreign_key: "users_id",            class_name: "::User"
    belongs_to :account,        foreign_key: "accounts_id",         class_name: "Account"  
    
    def self.index(current_user, query)
        privilege_groups = current_user.account.privilege_groups.select(
            :id,
            :name,
            :description,
            :created_at,
            "actions.total as actions_length"
        )
        .joins(:user_creator)
        .joins("
            left join  (
                select 
                    count(1) as total,
                    apga.account_privilege_groups_id as privilege_group_id
                from account_privilege_group_actions apga
                where apga.deleted_at is null
                group by apga.account_privilege_groups_id
            ) as actions 
                on actions.privilege_group_id = account_privilege_groups.id
        ")

        privilege_groups = privilege_groups.where("
            trim(lower(account_privilege_groups.name)) like '%#{query[:filters][:search].downcase}%' or  
            trim(lower(account_privilege_groups.description)) like '%#{query[:filters][:search].downcase}%'
        ") unless query[:filters][:search].blank?

        privilege_groups = privilege_groups
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderBy]} #{query[:pagination][:order]} NULLS LAST")

        LC::Response.pagination(
            privilege_groups.current_page,
            privilege_groups.total_pages,
            privilege_groups.total_count,
            privilege_groups.length,
            privilege_groups.map do |audience_document|
                audience_document.attributes.merge({
                    created_at_text: LC::Date.to_string_datetime(audience_document.created_at),
                    actions_length:  audience_document.actions_length ? audience_document.actions_length : 0
                })
            end
        )
    end

    def self.list(current_user, query)
        privilege_groups = current_user.account.privilege_groups.select(
            :id,
            :name,
            :description,
            :created_at,
            :account_privilege_groups_id
        )
        
        return privilege_groups
    end
    
    def role_group_actions(current_user, query)        
        actions = self.actions.select(
            "account_privilege_group_actions.id",
            :status,
            :category,
            "system_controllers.name as controller",
            "system_controllers.id as controller_id",
            "system_controller_actions.name as action",
            "system_controller_actions.id as action_id"
        )
        .joins(system_action: [:system_controller] )
        
        actions
    end
    
    def show(current_user, query)
        audience = current_user.account.privilege_groups.select(
            :id,
            :name,
            :description,
            :account_privilege_groups_id,
            LC::Date.db_timestamps()
        ).find(id)
    end
end
