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
class User::PrivilegeActionsController < ApplicationLesliController
    before_action :set_user_privilege_action, only: [:show, :update, :destroy]

    # GET /user/privilege_actions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::PrivilegeAction.index(current_user, @query))
            end
        end
    end

    # GET /user/privilege_actions/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @user_privilege_action
                return respond_with_successful(@user_privilege_action.show(current_user, @query))
            end
        end
    end

    # GET /user/privilege_actions/new
    def new
    end

    # GET /user/privilege_actions/1/edit
    def edit
    end

    # POST /user/privilege_actions
    def create
        user_privilege_action = User::PrivilegeAction.new(user_privilege_action_params)
        if user_privilege_action.save
            respond_with_successful(user_privilege_action)
        else
            respond_with_error(user_privilege_action.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /user/privilege_actions/1
    def update
        return respond_with_not_found unless @user_privilege_action

        if @user_privilege_action.update(user_privilege_action_params)
            respond_with_successful(@user_privilege_action.show(current_user, @query))
        else
            respond_with_error(@user_privilege_action.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/privilege_actions/1
    def destroy
        return respond_with_not_found unless @user_privilege_action

        if @user_privilege_action.destroy
            respond_with_successful
        else
            respond_with_error(@user_privilege_action.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_privilege_action
        @user_privilege_action = current_user.account.user_privilege_actions.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_privilege_action_params
        params.require(:user_privilege_action).permit(:id, :name)
    end
end
