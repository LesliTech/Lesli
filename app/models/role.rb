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
    has_many :privileges, class_name: "Role::Privilege", foreign_key: "roles_id"

    has_one :detail, inverse_of: :role, autosave: true, foreign_key: "roles_id", dependent: :destroy 
    accepts_nested_attributes_for :detail, update_only: true

    after_create :initialize_role

    def initialize_role

        if (self.detail.name == "admin")
            scan_routes(true)
        else
            scan_routes(false)
        end

    end

    def scan_routes(default)
        role_list = get_routes()
        role_list.each do |t|
            self.privileges.find_or_create_by!(grant_object: t[:grant_name]) do |privilege|
                privilege.grant_index = default, 
                privilege.grant_create = default, 
                privilege.grant_new = default, 
                privilege.grant_edit = default, 
                privilege.grant_show = default, 
                privilege.grant_update = default, 
                privilege.grant_destroy = default, 
                privilege.grant_options = default, 
                privilege.grant_default = default, 
                privilege.grant_empty = default
            end
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
        role_list = get_controllers_from_routes(role_list, CloudPanel::Engine.routes.routes, CloudPanel) if defined?(CloudPanel)
        role_list = get_controllers_from_routes(role_list, CloudBabel::Engine.routes.routes, CloudBabel) if defined?(CloudBabel)
        role_list = get_controllers_from_routes(role_list, DeutscheLeibrenten::Engine.routes.routes, DeutscheLeibrenten) if defined?(DeutscheLeibrenten)
        role_list = get_controllers_from_routes(role_list, CloudHouse::Engine.routes.routes, CloudHouse) if defined?(CloudHouse)
        role_list = get_controllers_from_routes(role_list, CloudFocus::Engine.routes.routes, CloudFocus) if defined?(CloudFocus)
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

            controller_list.push({ grant_name: controller})
        end
        return controller_list
    end        

end
