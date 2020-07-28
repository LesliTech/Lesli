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

    def initialize_role
        return scan_routes(true) if self.detail.name == "owner"
        return scan_routes(true) if self.detail.name == "admin"
        return scan_routes(false)
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
        .select(:name, :active)
        .where("roles.id = ?", id)
        .first

        {
            id: id,
            detail_attributes: data,
        }
    end

    def scan_routes(default)
        role_list = get_routes()
        role_list.each do |t|
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

            self.privileges.find_or_create_by!(grant_object: t[:grant_name]).update(attributes)
        end
    end

    def get_routes()
        role_list = []

        role_list = get_controllers_from_routes(role_list, Rails.application.routes.routes, "")
        role_list = get_controllers_from_routes(role_list, CloudTeam::Engine.routes.routes, CloudTeam) if defined?(CloudTeam)
        role_list = get_controllers_from_routes(role_list, CloudDriver::Engine.routes.routes, CloudDriver) if defined?(CloudDriver)
        role_list = get_controllers_from_routes(role_list, CloudLesli::Engine.routes.routes, CloudLesli) if defined?(CloudLesli)
        role_list = get_controllers_from_routes(role_list, CloudBell::Engine.routes.routes, CloudBell) if defined?(CloudBell)
        role_list = get_controllers_from_routes(role_list, CloudKb::Engine.routes.routes, CloudKb) if defined?(CloudKb)
        role_list = get_controllers_from_routes(role_list, CloudHelp::Engine.routes.routes, CloudHelp) if defined?(CloudHelp)
        role_list = get_controllers_from_routes(role_list, CloudNotes::Engine.routes.routes, CloudNotes) if defined?(CloudNotes)
        role_list = get_controllers_from_routes(role_list, CloudPanel::Engine.routes.routes, CloudPanel) if defined?(CloudPanel)
        role_list = get_controllers_from_routes(role_list, CloudBabel::Engine.routes.routes, CloudBabel) if defined?(CloudBabel)
        role_list = get_controllers_from_routes(role_list, CloudHouse::Engine.routes.routes, CloudHouse) if defined?(CloudHouse)
        role_list = get_controllers_from_routes(role_list, CloudFocus::Engine.routes.routes, CloudFocus) if defined?(CloudFocus)
        role_list = get_controllers_from_routes(role_list, CloudMailer::Engine.routes.routes, CloudMailer) if defined?(CloudMailer)
        role_list = get_controllers_from_routes(role_list, DeutscheLeibrenten::Engine.routes.routes, DeutscheLeibrenten) if defined?(DeutscheLeibrenten)

        role_list
    end

    def get_controllers_from_routes controller_list, routes, engine
        routes = routes.map{ |r| {controller: r.defaults[:controller] }}.uniq
        routes.each do |route|
            controller = route[:controller]
            next if !(controller.present?)
            next if controller.include? "rails"
            next if controller.include? "action_mailbox"
            next if controller.include? "active_storage"
            next if controller.include? "errors"
            next if controller.include? "application"

            controller_list.push({ grant_name: controller})
        end
        return controller_list
    end        

end
