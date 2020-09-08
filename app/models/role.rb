=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Role < ApplicationRecord
    
    belongs_to :account, foreign_key: "accounts_id"
    has_many :users, foreign_key: "roles_id"
    has_many :privileges, class_name: "Role::Privilege", foreign_key: "roles_id", dependent: :delete_all
    has_many :privilege_defaults, class_name: "Role::PrivilegeDefault", foreign_key: "roles_id", dependent: :delete_all

    has_one :detail, inverse_of: :role, autosave: true, foreign_key: "roles_id", dependent: :destroy 
    accepts_nested_attributes_for :detail, update_only: true

    after_create :initialize_role

    def destroy(*args)
        super
        rescue ActiveRecord::InvalidForeignKey => error
    end

    def initialize_role
        return scan_routes(true) if self.detail.name == "owner"
        return scan_routes(true) if self.detail.name == "admin"
        return scan_routes()
    end

    def self.index(current_user, query_params)
        roles = current_user.account.roles
                .left_joins(:detail)
                .select("
                    roles.id,
                    role_details.name,
                    role_details.active
                ")
        
        if(query_params[:include] == "count")
            roles = roles.select("count(u.id) as users_count")
                        .joins("left join users as u on u.roles_id = roles.id")
                        .group("roles.id, role_details.name, role_details.active")
        end

        roles
    end

    def show()
        data = Role
        .left_joins(:detail)
        .select(:id, :name, :active, :object_level_permission)
        .where("roles.id = ?", id)
        .first

        {
            id: id,
            detail_attributes: data,
        }
    end

    def scan_routes(default = false)
        routes = LC::System::Routes.scan
        routes.each do |route|
            attributes = {
                grant_index: default, 
                grant_edit: default, 
                grant_show: default, 
                grant_new: default, 
                grant_create: default, 
                grant_update: default, 
                grant_destroy: default, 
                grant_search: default,
                grant_resources: default,
                grant_options: default 
            }

            attributes = attributes.merge({
                grant_object: route[:controller]
            })

            self.privileges.find_or_create_by(attributes)
            self.privilege_defaults.find_or_create_by(attributes)
        end
    end        
end
