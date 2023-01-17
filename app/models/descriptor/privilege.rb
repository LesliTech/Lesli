=begin
Copyright (c) 2022, all rights reserved.

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
class Descriptor::Privilege < ApplicationLesliRecord
    belongs_to :descriptor, foreign_key: "descriptors_id"

    validates :controller, presence: true
    validates :action, presence: true

    def self.index current_user, query, params
        SystemController.joins(:actions)
        .select(
            "system_controllers.name as controller",
            "system_controllers.id as controller_id",
            "system_controller_actions.name as action",
            "system_controller_actions.id as action_id",
            Descriptor::Privilege
                .where("controller = system_controllers.name")
                .where("action = system_controller_actions.name")
                .where("descriptors_id = ?", params[:descriptor_id])
                .arel.exists.as("active")
        ).order("system_controllers.name", "system_controller_actions.name")

    end
end
