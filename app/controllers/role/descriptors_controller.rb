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
class Role::DescriptorsController < ApplicationController
    before_action :set_role_descriptor, only: [:show, :update, :destroy]

    # POST /role/descriptors
    def create
        role_descriptor = Role::Descriptor.new(role_descriptor_params)
        if role_descriptor.save
            respond_with_successful(role_descriptor)
        else
            respond_with_error(role_descriptor.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/descriptors/1
    def destroy
        return respond_with_not_found unless @role_descriptor

        if @role_descriptor.destroy
            respond_with_successful
        else
            respond_with_error(@role_descriptor.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_descriptor
        @role_descriptor = current_user.account.role_descriptors.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_descriptor_params
        params.require(:role_descriptor).permit(:id, :name)
    end
end
