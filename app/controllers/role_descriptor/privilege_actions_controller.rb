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
class RoleDescriptor::PrivilegeActionsController < ApplicationLesliController
    before_action :set_role_descriptor_privilege, only: [:index, :create]
    before_action :set_role_descriptor_privilege_action, only: [:show, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(RoleDescriptor::PrivilegeAction.index(current_user, @role_descriptor, @query))
            end
        end
    end
    
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_descriptor_privilege_action
                return respond_with_successful(@role_descriptor_privilege_action.show(current_user, @query))
            end
        end
    end

    def new
    end
    
    def edit
    end
    
    def create
        return respond_with_not_found unless @role_descriptor
        
        role_descriptor_privilege_action = @role_descriptor.privilege_actions.new(role_descriptor_privilege_action_params)
        
        if role_descriptor_privilege_action.save
            respond_with_successful(role_descriptor_privilege_action)
        else
            respond_with_error(role_descriptor_privilege_action.errors.full_messages.to_sentence)
        end
    end

    def update
        return respond_with_not_found unless @role_descriptor_privilege_action

        if @role_descriptor_privilege_action.update(role_descriptor_privilege_action_params)
            respond_with_successful(@role_descriptor_privilege_action.show(current_user, @query))
        else
            respond_with_error(@role_descriptor_privilege_action.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @role_descriptor_privilege_action

        if @role_descriptor_privilege_action.destroy
            respond_with_successful
        else
            respond_with_error(@role_descriptor_privilege_action.errors.full_messages.to_sentence)
        end
    end

    def options 
        options = RoleDescriptor::PrivilegeAction.options(current_user)
        
        respond_with_successful(options)
    end
    
    private
    
    def set_role_descriptor_privilege
        @role_descriptor = current_user.account.role_descriptors.find_by(id: params[:role_descriptor_id])
    end
    
    def set_role_descriptor_privilege_action
        set_role_descriptor_privilege
        
        return respond_with_not_found unless @role_descriptor
        
        @role_descriptor_privilege_action = @role_descriptor.privilege_actions.find_by(id: params[:id])
    end

    def role_descriptor_privilege_action_params
        params.require(:role_descriptor_privilege_action).permit(
            :status, 
            :category,
            :system_controller_actions_id
        )
    end
end
