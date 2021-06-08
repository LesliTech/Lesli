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
class Account::PrivilegeGroupActionsController < ApplicationLesliController
    before_action :set_account_privilege_group,  only: [:index]
    before_action :set_account_privilege_group_action, only: [:show, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::PrivilegeGroupAction.index(current_user, @account_privilege_group , @query))
            end
        end
    end
    
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_privilege_group_action
                return respond_with_successful(@account_privilege_group_action.show(current_user, @query))
            end
        end
    end

    def new
    end

    def edit
    end
    
    def create
        account_privilege_group_action = Account::PrivilegeGroupAction.new(account_privilege_group_action_params)
        if account_privilege_group_action.save
            respond_with_successful(account_privilege_group_action)
        else
            respond_with_error(account_privilege_group_action.errors.full_messages.to_sentence)
        end
    end

    def update
        return respond_with_not_found unless @account_privilege_group_action

        if @account_privilege_group_action.update(account_privilege_group_action_params)
            respond_with_successful(@account_privilege_group_action.show(current_user, @query))
        else
            respond_with_error(@account_privilege_group_action.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @account_privilege_group_action

        if @account_privilege_group_action.destroy
            respond_with_successful
        else
            respond_with_error(@account_privilege_group_action.errors.full_messages.to_sentence)
        end
    end

    private

    def options 
        respond_with_successful(Account::PrivilegeGroupAction.options(current_user))
    end
    
    def set_account_privilege_group
        @account_privilege_group = current_user.account.privilege_groups.find_by(id: account_privilege_group_action_params[:account_privilege_group_id])
    end
    
    def set_account_privilege_group_action
        set_account_privilege_group
        
        @account_privilege_group_action = @account_privilege_group.actions.find_by(id: params[:id])
    end

    def account_privilege_group_action_params
        params.require(:account_privilege_group_action).permit(
            :status, 
            :account_privilege_group_id
        )
    end
end
