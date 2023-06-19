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

class Descriptor::PrivilegesController < ApplicationLesliController
    before_action :set_descriptor, only: [:create, :destroy]
    before_action :set_descriptor_privilege, only: [:destroy]


    # GET /descriptor/privileges
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Descriptor::Privilege.index(current_user, @query, params))
            end
        end
    end

    # POST /descriptor/privileges
    def create

        descriptor_privilege_status = false

        descriptor_privilege = @descriptor.privileges.with_deleted.find_by(
            :system_controller_action_id => descriptor_privilege_params[:action_id]
        )
        
        if not descriptor_privilege
            descriptor_privilege = @descriptor.privileges.new(
                :system_controller_action_id => descriptor_privilege_params[:action_id]
            )
            descriptor_privilege_status = descriptor_privilege.save
        elsif descriptor_privilege.deleted?
            descriptor_privilege_status = descriptor_privilege.recover
        end

        if descriptor_privilege_status
            #Role::Activity.log_create_descriptor(current_user, @role, role_descriptor)
            respond_with_successful(descriptor_privilege)
        else
            respond_with_error(descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # DELETE /descriptor/privileges/1
    def destroy
        if @descriptor_privilege.destroy
            respond_with_successful
        else
            respond_with_error(@descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor
        @descriptor = current_user.account.descriptors.find_by_id(params[:descriptor_id])
        return respond_with_not_found if @descriptor.blank?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor_privilege
        @descriptor_privilege = @descriptor.privileges.find_by_id(params[:id])
        return respond_with_not_found if @descriptor_privilege.blank?
    end

    # Only allow a list of trusted parameters through.
    def descriptor_privilege_params
        params.require(:descriptor_privilege).permit(:id, :name, :action_id)
    end
end
