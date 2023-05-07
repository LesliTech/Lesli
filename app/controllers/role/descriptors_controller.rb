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
class Role::DescriptorsController < ApplicationLesliController
    before_action :set_role, only: [:index]
    before_action :set_role_descriptor, only: [:show, :update, :destroy]

    def index 
        respond_with_successful(Role::Descriptor.index(current_user, @query, @role))
    end

    # POST /role/descriptors
    def create
        role_descriptor = @role.descriptors.new(role_descriptor_params)
        
        if role_descriptor.save
            Role::Activity.log_create_descriptor_assignment(current_user, @role, role_descriptor)
            respond_with_successful(role_descriptor)
        else
            respond_with_error(role_descriptor.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/descriptors/1
    def destroy
        return respond_with_not_found unless @role_descriptor

        if @role_descriptor.destroy
            Role::Activity.log_destroy_descriptor_assignment(current_user, @role, @role_descriptor)
            respond_with_successful
        else
            respond_with_error(@role_descriptor.errors.full_messages.to_sentence)
        end
    end

    private

    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end

    def set_role_descriptor
        set_role 
        return respond_with_not_found unless @role 
        @role_descriptor = @role.descriptors.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_descriptor_params
        params.require(:role_descriptor).permit(:id, :name, :privilege_index)
    end
end
