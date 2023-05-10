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

class User::RolesController < ApplicationLesliController
    before_action :set_user, only: [:index, :create, :destroy]
    before_action :set_user_role, only: [:create, :destroy]

    # Get the list of assigned roles of the requested user
    # we filter the roles according to the object level permission
    # of the current_user
    def index 
        #respond_with_successful(@user.available_roles)
        respond_with_successful(RoleServices.new(current_user).available_roles_for(@user))
    end

    # POST /user/:user_id/roles
    def create
        # get the role to assign to the user
        role = current_user.account.roles.find(user_role_params[:id])

        unless can_current_user_work_with_role?(role)
            return respond_with_error(I18n.t("core.roles.messages_danger_cannot_assign_level_of_role"))
        end

        # create new role for user if it does not exist
        @user.user_roles.find_or_create_by({ role: role })

        respond_with_successful(@user.roles)

        User.log_activity_create_user_role(current_user, @user, role)
    end

    # DELETE /user/:user_id/roles/:role_id
    def destroy

        # get the role to assign to the user
        role = current_user.account.roles.find(@user_role.role.id)

        unless can_current_user_work_with_role?(role)
            return respond_with_error(I18n.t("core.roles.messages_danger_cannot_modify_role"))
        end

        @user_role.destroy

        respond_with_successful(@user.roles)

        User.log_activity_destroy_user_role(current_user, @user, role)
    end

    private

    def can_current_user_work_with_role?(role)
        # check if the current_user can assign this role, current user cannot assign role if
        #   role to assign has greater object level permission than the greater role assigned to the current user
        #   role to assign is the same of the greater role assigned to the current user
        #   current user is not admin or owner
        current_user.roles.each do |current_role|
            return true if current_role.object_level_permission > role.object_level_permission
            return true if current_role.name == "owner"
        end

        # check if user can work with that object level permission
        user_role_level_max = current_user.roles.map(&:object_level_permission).max()
        return false if role.object_level_permission > user_role_level_max
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = current_user.account.users.find(params[:user_id])
    end

    def set_user_role
        @user_role = @user.user_roles.find_by(:roles_id => params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_role_params
        params.require(:user_role).permit(:id)
    end

end
