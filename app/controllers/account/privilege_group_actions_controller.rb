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
    before_action :set_account_privilege_group_action, only: [:show, :update, :destroy]

    # GET /account/privilege_group_actions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::PrivilegeGroupAction.index(current_user, @query))
            end
        end
    end

    # GET /account/privilege_group_actions/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_privilege_group_action
                return respond_with_successful(@account_privilege_group_action.show(current_user, @query))
            end
        end
    end

    # GET /account/privilege_group_actions/new
    def new
    end

    # GET /account/privilege_group_actions/1/edit
    def edit
    end

    # POST /account/privilege_group_actions
    def create
        account_privilege_group_action = Account::PrivilegeGroupAction.new(account_privilege_group_action_params)
        if account_privilege_group_action.save
            respond_with_successful(account_privilege_group_action)
        else
            respond_with_error(account_privilege_group_action.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/privilege_group_actions/1
    def update
        return respond_with_not_found unless @account_privilege_group_action

        if @account_privilege_group_action.update(account_privilege_group_action_params)
            respond_with_successful(@account_privilege_group_action.show(current_user, @query))
        else
            respond_with_error(@account_privilege_group_action.errors.full_messages.to_sentence)
        end
    end

    # DELETE /account/privilege_group_actions/1
    def destroy
        return respond_with_not_found unless @account_privilege_group_action

        if @account_privilege_group_action.destroy
            respond_with_successful
        else
            respond_with_error(@account_privilege_group_action.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_privilege_group_action
        @account_privilege_group_action = current_user.account.account_privilege_group_actions.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_privilege_group_action_params
        params.require(:account_privilege_group_action).permit(:id, :name)
    end
end
