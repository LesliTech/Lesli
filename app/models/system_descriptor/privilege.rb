
class SystemDescriptor::Privilege < ApplicationLesliRecord
    belongs_to :system_descriptor, foreign_key: "system_descriptors_id"

    def self.index current_user, query, params
        SystemController.joins(:actions)
        .joins(sanitize_sql_array(["
            LEFT JOIN descriptor_privileges
            ON descriptor_privileges.system_controller_actions_id = system_controller_actions.id 
	        AND descriptors_id = ?", params[:descriptor_id]])
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
