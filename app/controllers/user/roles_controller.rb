=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class User::RolesController < ApplicationLesliController
    before_action :set_user, only: [:index, :create, :destroy]
    before_action :set_user_role, only: [:destroy]

    # Get the list of assigned roles of the requested user
    # we filter the roles according to the object level permission
    # of the current_user
    def index 
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
        user_role = @user.user_roles.with_deleted.find_or_create_by({ role: role })

        # if role was soft deleted we need to recover it instead of create a new record
        user_role.recover if user_role.deleted?

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
        @user_role = @user.user_roles.find_by(:role_id => params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_role_params
        params.require(:user_role).permit(:id)
    end

end
