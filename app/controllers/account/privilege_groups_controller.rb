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
class Account::PrivilegeGroupsController < ApplicationLesliController
    before_action :set_account_privilege_group, only: [:update, :destroy, :actions]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::PrivilegeGroup.index(current_user, @query))
            end
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json do
                set_account_privilege_group
                
                return respond_with_not_found unless @account_privilege_group
                return respond_with_successful(@account_privilege_group.show(current_user, @query))
            end
        end
    end

    def new
    end

    def edit
    end

    def create
        account_privilege_group = current_user.account.privilege_groups.new(account_privilege_group_params)
        account_privilege_group.user_creator = current_user
        
        if account_privilege_group.save
            respond_with_successful(account_privilege_group)
        else
            respond_with_error(account_privilege_group.errors.full_messages.to_sentence)
        end
    end

    def update
        return respond_with_not_found unless @account_privilege_group

        if @account_privilege_group.update(account_privilege_group_params)
            respond_with_successful(@account_privilege_group.show(current_user, @query))
        else
            respond_with_error(@account_privilege_group.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @account_privilege_group

        if @account_privilege_group.destroy
            respond_with_successful
        else
            respond_with_error(@account_privilege_group.errors.full_messages.to_sentence)
        end
    end

    def actions         
        return respond_with_not_found unless @account_privilege_group
        
        respond_with_successful(@account_privilege_group.role_group_actions(current_user, @query))
    end
    
    private

    def set_account_privilege_group
        @account_privilege_group = current_user.account.privilege_groups.find_by(id: params[:id])
    end

    def account_privilege_group_params
        params.require(:account_privilege_group).permit(
            :name,
            :description
        )
    end
end
