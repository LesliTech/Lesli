class User::RolesController < ApplicationLesliController
    before_action :set_user, only: [:create, :destroy]
    before_action :set_user_role, only: [:create, :destroy]

    # POST /user/roles
    def create

        role = current_user.account.roles.find(user_role_params[:id])

        result = @user.user_roles.create({
            role: role
        })

        respond_with_successful([result])

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
