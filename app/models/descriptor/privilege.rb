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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Descriptor::Privilege < ApplicationLesliRecord
    belongs_to :descriptor
    belongs_to :system_controller_action, class_name: "SystemController::Action"

    def self.index current_user, query, params

        SystemController.joins(:actions)
        .joins(sanitize_sql_array(["
            LEFT JOIN descriptor_privileges
            ON descriptor_privileges.system_controller_action_id = system_controller_actions.id 
	        AND descriptor_id = ?", params[:descriptor_id]])
        ).select(
            "system_controllers.name as controller",
            "system_controllers.id as controller_id",
            "system_controller_actions.name as action",
            "system_controller_actions.id as action_id",
            "descriptor_privileges.id as descriptor_privilege_id"
        ).order(
            "system_controllers.name", 
            "system_controller_actions.name"
        )
    end
end
