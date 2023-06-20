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
class SystemDescriptor::PrivilegesController < ApplicationController
    before_action :set_system_descriptor_privilege, only: [:show, :update, :destroy]

    # GET /system_descriptor/privileges
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(SystemDescriptor::Privilege.index(current_user, @query))
            end
        end
    end

    # GET /system_descriptor/privileges/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @system_descriptor_privilege
                return respond_with_successful(@system_descriptor_privilege.show(current_user, @query))
            end
        end
    end

    # GET /system_descriptor/privileges/new
    def new
    end

    # GET /system_descriptor/privileges/1/edit
    def edit
    end

    # POST /system_descriptor/privileges
    def create
        system_descriptor_privilege = SystemDescriptor::Privilege.new(system_descriptor_privilege_params)
        if system_descriptor_privilege.save
            respond_with_successful(system_descriptor_privilege)
        else
            respond_with_error(system_descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /system_descriptor/privileges/1
    def update
        return respond_with_not_found unless @system_descriptor_privilege

        if @system_descriptor_privilege.update(system_descriptor_privilege_params)
            respond_with_successful(@system_descriptor_privilege.show(current_user, @query))
        else
            respond_with_error(@system_descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # DELETE /system_descriptor/privileges/1
    def destroy
        return respond_with_not_found unless @system_descriptor_privilege

        if @system_descriptor_privilege.destroy
            respond_with_successful
        else
            respond_with_error(@system_descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_system_descriptor_privilege
        @system_descriptor_privilege = current_user.account.system_descriptor_privileges.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def system_descriptor_privilege_params
        params.require(:system_descriptor_privilege).permit(:id, :name)
    end
end
