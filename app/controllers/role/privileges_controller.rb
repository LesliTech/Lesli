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
class Role::PrivilegesController < ApplicationController
    before_action :set_role_privilege, only: [:show, :update, :destroy]

    # GET /role/privileges
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Role::Privilege.index(current_user, @query))
            end
        end
    end

    # GET /role/privileges/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_privilege
                return respond_with_successful(@role_privilege.show(current_user, @query))
            end
        end
    end

    # GET /role/privileges/new
    def new
    end

    # GET /role/privileges/1/edit
    def edit
    end

    # POST /role/privileges
    def create
        role_privilege = Role::Privilege.new(role_privilege_params)
        if role_privilege.save
            respond_with_successful(role_privilege)
        else
            respond_with_error(role_privilege.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /role/privileges/1
    def update
        return respond_with_not_found unless @role_privilege

        if @role_privilege.update(role_privilege_params)
            respond_with_successful(@role_privilege.show(current_user, @query))
        else
            respond_with_error(@role_privilege.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/privileges/1
    def destroy
        return respond_with_not_found unless @role_privilege

        if @role_privilege.destroy
            respond_with_successful
        else
            respond_with_error(@role_privilege.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_privilege
        @role_privilege = current_user.account.role_privileges.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_privilege_params
        params.require(:role_privilege).permit(:id, :name)
    end
end
