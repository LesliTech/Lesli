class User::RolesController < ApplicationLesliController
    before_action :set_user, only: [:create, :destroy]
    before_action :set_user_role, only: [:create, :destroy]

    # POST /user/roles
    def create

        can_assign_role = false

        # get the role to assign to the user
        role = current_user.account.roles.find(user_role_params[:id])

        # check if the current_user can assign this role, current user cannot assign role if
        #   role to assign has greater object level permission than the greater role assigned to the current user
        #   role to assign is the same of the greater role assigned to the current user
        #   current user is not admin or owner
        current_user.roles.each do |current_role|
            can_assign_role = true if current_role.object_level_permission > role.object_level_permission 
            can_assign_role = true if current_role.name == "owner"
            break if can_assign_role == true
        end


        if not can_assign_role
            return respond_with_error("You cannot assign this level of role")
        end

        # create new role for user if it does not exist
        @user.user_roles.find_or_create_by({ role: role })

        respond_with_successful(@user.roles)

    end

    # DELETE /user/roles/1
    def destroy
        respond_with_successful(@user_role.destroy)
    end

    private

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
