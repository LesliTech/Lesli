=begin

Copyright (c) 2023, all rights reserved.

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

class Descriptor::PrivilegeServices < ApplicationLesliServices

    def find id
        super(current_user.account.roles.find_by(id: id))
    end

    def self.index descriptor_id=nil

        SystemController.joins(:actions)
        .joins("
            LEFT JOIN descriptor_privileges
            ON descriptor_privileges.system_controller_action_id = system_controller_actions.id 
	        "
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
