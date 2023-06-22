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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Role::DescriptorsController < ApplicationLesliController
    before_action :set_role, only: [:index, :show, :update, :create, :destroy]
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
