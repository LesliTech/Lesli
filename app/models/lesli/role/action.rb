=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli 
    class Role::Action < ApplicationLesliRecord
        belongs_to :role

        after_commit :synchronize_privileges
        after_destroy :synchronize_privileges

        belongs_to :action, class_name: "SystemController::Action"
        belongs_to :system_controller_action, class_name: "SystemController::Action", foreign_key: "action_id"

        def synchronize_privileges
            Lesli::RoleOperator.new(self).synchronize
        end

        def self.index current_user, query, role

            #role.descriptors
            Descriptor
            .joins(:privileges)
            .left_joins(:role_descriptors)
            .joins(%(
                inner join system_controller_actions  
                on system_controller_actions.id = descriptor_privileges.system_controller_action_id
            )).joins(%(
                inner join system_controllers  
                on system_controllers.id = system_controller_actions.system_controller_id
            ))
            .select(
                "coalesce(role_descriptors.descriptor_id, descriptors.id) as id", 
                "descriptors.name as name", 
                "system_controllers.reference as reference", 
                "system_controllers.route as controller", 
                #"descriptors.category as action", 
                "system_controller_actions.name as action", 
                "system_controllers.engine as engine", 
                "case when role_descriptors.descriptor_id is null then false else true end as active"
            )
        end
    end
end
