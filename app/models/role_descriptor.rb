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
    
    has_many :activities,                 foreign_key: "role_descriptors_id"
    
    belongs_to :user_creator,   foreign_key: "users_id",            class_name: "::User",   optional: true
    belongs_to :account,        foreign_key: "accounts_id",         class_name: "Account"  
    
    after_create :add_privilege_actions
    
    def add_privilege_actions   
        default_role_descriptor_actions = RoleDescriptor::DefaultPrivilegeActionsService.new
          
        if (self.name == "admin" ||self.name == "owner")
            controllers = LC::System::Controllers.scan
            
            controllers.each do |controller_name, controller_actions|                 
                controller = SystemController.find_or_create_by(name: controller_name)      
                
                controller_actions.each do |action|                       
                    system_action = controller.actions.find_or_create_by(name: action)
                    role_descriptor_action = self.privilege_actions.find_or_create_by( 
                        system_action: system_action
                    )

                    role_descriptor_action.update(status: true)
                end
            end
        end
        
        if (RoleDescriptor::DefaultPrivilegeActionsService.method_defined? "#{self.name}_actions") # Adding privileges if the method is defined on the class
            RoleDescriptor::DefaultPrivilegeActionsService.new.send("#{self.name}_actions").each do |system_action|
                self.privilege_actions.find_or_create_by(
                    category: RoleDescriptor::PrivilegeAction.categories["update"], 
                    system_action: system_action
                ).update(status: TRUE)
            end
        end
    end
    
    def self.index(current_user, query)
        role_descriptors = current_user.account.role_descriptors.select(
            :id,
            :name,
            :description,
            :created_at,
            "coalesce(actions.total, 0) as actions_length",
            LC::Date2.new.date_time.db_timestamps("role_descriptors", "created_at_text")
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
        .where.not("role_descriptors.name in (?)", ["admin", "owner", "profile"])

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
            role_descriptors
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
        .where.not("role_descriptors.name in (?)", ["admin", "owner", "profile"]) # Role descriptors which a user is not able to edit edit
        
        return role_descriptors
    end
    
    def show(current_user, query)
        current_user.account.role_descriptors.select(
            :id,
            :name,
            :description,
            :role_descriptors_id,
            LC::Date.db_timestamps()
        ).find(id)
    end
    
    def has_roles_assigned?
        return Role::DescriptorAssignment.where(descriptor: self).count > 0
    end
end
