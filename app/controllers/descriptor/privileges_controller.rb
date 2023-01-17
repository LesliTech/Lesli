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
class Descriptor::PrivilegesController < ApplicationLesliController
    before_action :set_descriptor_privilege, only: [:create, :destroy]

    def index 
        respond_with_successful(Descriptor::Privilege.index(current_user, @query, params))
    end

    def create 

        system_controller = SystemController.joins(:actions)
        .where("system_controllers.id = ?", descriptor_privilege_params[:controller_id])
        .where("system_controller_actions.id = ?", descriptor_privilege_params[:action_id])
        .select(
            "system_controllers.name as controller_name",
            "system_controller_actions.name as action_name"
        ).first

        descriptor_privilege = @descriptor.privileges.create(
            :controller => system_controller[:controller_name],
            :action => system_controller[:action_name]
        )

        respond_with_successful(descriptor_privilege)
    end

    def destroy 
        return respond_with_not_found unless @descriptor_privilege
        if @descriptor_privilege.delete
            respond_with_successful(@descriptor_privilege)
        else
            respond_with_error(@descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor_privilege
        @descriptor = current_user.account.descriptors.find_by(:id => params[:descriptor_id])
        @descriptor_privilege = @descriptor.privileges.find_by(:id => params[:id])
    end

    # Only allow a list of trusted parameters through.
    def descriptor_privilege_params
        params.fetch(:descriptor_privilege, {}).permit(:id, :controller_id, :action_id)
    end
end
