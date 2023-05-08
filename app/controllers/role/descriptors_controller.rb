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
    before_action :set_role
    before_action :set_role_descriptor, only: [:show, :update, :destroy]

    def index 
        respond_with_successful(Role::Descriptor.index(current_user, @query, @role))
    end

    # POST /role/descriptors
    def create

        role_descriptor_status = false

        system_descriptor = SystemDescriptor.find_by(:id => role_descriptor_params[:id])
        role_descriptor = @role.descriptors.with_deleted.find_by(:system_descriptor => system_descriptor)
        
        if not role_descriptor
            role_descriptor = @role.descriptors.new(:system_descriptor => system_descriptor)
            role_descriptor_status = role_descriptor.save
        elsif role_descriptor.deleted?
            role_descriptor_status = role_descriptor.recover
        end

        if role_descriptor_status
            Role::Activity.log_create_descriptor(current_user, @role, role_descriptor)
            respond_with_successful(role_descriptor)
        else
            respond_with_error(role_descriptor.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/descriptors/1
    def destroy
        return respond_with_not_found unless @role_descriptor

        if @role_descriptor.destroy
            Role::Activity.log_destroy_descriptor(current_user, @role, @role_descriptor)
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
        return respond_with_not_found unless @role 
        @role_descriptor = @role.descriptors.find_by(system_descriptors_id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_descriptor_params
        params.require(:role_descriptor).permit(:id, :name, :privilege_index)
    end
end
