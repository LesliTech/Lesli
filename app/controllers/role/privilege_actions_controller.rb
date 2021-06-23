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
    before_action :set_role, only: [:index] 
    before_action :set_role_privilege_action, only: [:update] 
    
    def index 
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_successful(Role::PrivilegeAction.index(current_user, @role))
            }
        end
    end
    
    def update
        return respond_with_not_found unless @role_privilege_action
        
        # cannot be disabled if the privilege action it is include in a group added to the role
        if !role_privilege_action_params[:status]
            
            privilege_action_available = @role_privilege_action.is_available?
            
            if !privilege_action_available[:status]
                return respond_with_error(
                    I18n.t(
                        "core.role/privilege_actions.messages_danger_action_blocked_by_group", 
                        action: @role_privilege_action.action.name,
                        groups: privilege_action_available[:groups]
                    )
                )
            end
        end
        
        if @role_privilege_action.update(role_privilege_action_params)
            respond_with_successful(@role_privilege_action.show(current_user, @query))
        else
            respond_with_error(@role_privilege_action.errors.full_messages.to_sentence)
        end
    end
    
    def options
        respond_with_successful(Role::PrivilegeAction.options(current_user, @query))
    end
    
    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end
    
    def set_role_privilege_action
        set_role
        
        return respond_with_not_found unless @role
        
        @role_privilege_action = @role.role_privilege_actions.find_by(id: params[:id])
    end
    
    def role_privilege_action_params
        params.require(:role_privilege_action).permit(
            :status
        )
    end
end
