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

class Role::DescribersController < ApplicationLesliController
    before_action :set_role, only: [:index, :create, :destroy]
    before_action :set_role_describer, only: [:destroy]

    def privileges 
        {
            create: []
        }
    end

    def index 
        respond_with_successful(Role::Describer.index(current_user, @query, @role))
    end 

    def create 

        # check if current user can work with role
        unless current_user.can_work_with_role?(@role)
            return respond_with_error(I18n.t("core.roles.messages_danger_updating_role_object_level_permission_too_high"))
        end

        describer = @role.describers.new({ :descriptors_id => role_describer_params[:id] })

        if describer.save
            respond_with_successful(describer)
        else
            respond_with_error(describer.errors.full_messages.to_sentence)
        end
    end

    private

    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_role_describer
        @role_describer = @describers.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_describer_params
        params.require(:role_describer).permit(:id)
    end
end
