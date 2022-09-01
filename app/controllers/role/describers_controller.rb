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

        # check if the descriptor is already registered in the database
        describer = @role.describers.with_deleted.find_by(descriptors_id: role_describer_params[:id])

        # if descriptor already exists
        if describer
            # just restore ir (undelete)
            describer.update(:deleted_at => nil) 
            Role::Activity.log_create_descriptor_assignment(current_user, @role, describer) 
            return respond_with_successful
        end 

        # if descriptor does not exists (even deleted), insert the new descriptor to the role
        describer = @role.describers.create({ :descriptors_id => role_describer_params[:id] })
        
        Role::Activity.log_create_descriptor(current_user, @role, describer)    
        respond_with_successful()

    end

    def destroy 

        # check if current user can work with role
        unless current_user.can_work_with_role?(@role)
            return respond_with_error(I18n.t("core.roles.messages_danger_updating_role_object_level_permission_too_high"))
        end

        if @role_describer.destroy
            respond_with_successful
            Role::Activity.log_destroy_descriptor(current_user, @role, @role_describer)
        else
            respond_with_error(@role_describer.errors.full_messages.to_sentence)
        end

    end 

    private

    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_role_describer
        @role_describer = @role.describers.with_deleted.find_by(descriptors_id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_describer_params
        params.require(:role_describer).permit(:id)
    end
end
