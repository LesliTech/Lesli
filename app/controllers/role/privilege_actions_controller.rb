=begin
Copyright (c) 2021, all rights reserved.

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
class Role::PrivilegeActionsController < ApplicationLesliController
    before_action :set_role_privilege_action, only: [:show, :update, :destroy]

    # GET /role/privilege_actions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Role::PrivilegeAction.index(current_user, @query))
            end
        end
    end

    # GET /role/privilege_actions/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_privilege_action
                return respond_with_successful(@role_privilege_action.show(current_user, @query))
            end
        end
    end

    # GET /role/privilege_actions/new
    def new
    end

    # GET /role/privilege_actions/1/edit
    def edit
    end

    # POST /role/privilege_actions
    def create
        role_privilege_action = Role::PrivilegeAction.new(role_privilege_action_params)
        if role_privilege_action.save
            respond_with_successful(role_privilege_action)
        else
            respond_with_error(role_privilege_action.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /role/privilege_actions/1
    def update
        return respond_with_not_found unless @role_privilege_action

        if @role_privilege_action.update(role_privilege_action_params)
            respond_with_successful(@role_privilege_action.show(current_user, @query))
        else
            respond_with_error(@role_privilege_action.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/privilege_actions/1
    def destroy
        return respond_with_not_found unless @role_privilege_action

        if @role_privilege_action.destroy
            respond_with_successful
        else
            respond_with_error(@role_privilege_action.errors.full_messages.to_sentence)
        end
    end

    def options
        respond_with_successful(Role::PrivilegeAction.options(current_user, @query))
    end
    
    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_privilege_action
        @role_privilege_action = current_user.account.role_privilege_actions.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_privilege_action_params
        params.require(:role_privilege_action).permit(:id, :name)
    end
end
