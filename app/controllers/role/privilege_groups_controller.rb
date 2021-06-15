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
class Role::PrivilegeGroupsController < ApplicationLesliController
    before_action :set_role, only: [:index, :create]
    before_action :set_role_privilege_group, only: [:destroy]

    def index        
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_successful(@role.privilege_groups)
            }
        end
    end
    
    def create
        role_privilege_group = @role.privilege_groups.new(role_privilege_group_params)
        
        if role_privilege_group.save
            respond_with_successful(role_privilege_group)
        else
            respond_with_error(role_privilege_group.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @role_privilege_group

        if @role_privilege_group.destroy
            respond_with_successful
        else
            respond_with_error(@role_privilege_group.errors.full_messages.to_sentence)
        end
    end

    private

    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end
    
    def set_role_privilege_group
        set_role 
        
        return respond_with_not_found unless @role 
        
        @role_privilege_group = @role.privilege_groups.find_by(id: params[:id])
    end

    def role_privilege_group_params        
        params.require(:role_privilege_group).permit(
            :account_privilege_groups_id,
            :category
        )
    end
end
