class UsersController < ApplicationLesliController
    before_action :set_user, only: [:show, :update]
    before_action :check_has_authorization, only: [:update]

    def index
        respond_to do |format|
            format.json {
                responseWithSuccessful(User.list(current_user, params[:role], params[:type], @query))
            }
        end
    end

    def show

        # Only admins can show the user information
        # If not admin, only the user can see his own information
        unless current_user.is_role?("owner", "admin") or current_user.id == @user.id
            return responseWithUnauthorized
        end

        respond_to do |format|
            format.json {
                return responseWithNotFound unless @user
                responseWithSuccessful(@user.show)
            }
        end

    end

    def create
        user = User.new(user_params)
        user.password = Devise.friendly_token
        user.account = current_user.account
        user.confirm

        if user.save
            responseWithSuccessful(user)
            User.send_password_reset(user)
        else
            responseWithError(user.errors.full_messages.to_sentence)
        end
    end

    def update 
        return responseWithNotFound unless @user

        if @user.update(user_params)
            responseWithSuccessful
        else
            responseWithError(@user.errors.full_messages.to_sentence)
        end
    end

    def set_user
        @user = current_user.account.users.find_by(id: params[:id])
    end

    def check_has_authorization
        if !is_admin?()  && !only_active_param()
            return responseWithUnauthorized if current_user != @user
        end
    end

    private 

    def only_active_param
        return user_params.keys.size == 1 && user_params.has_key?("active")
    end
    
    def user_params
        params.require(:user).permit(
            :name,
            :email,
            :role,
            :active
        )
    end
end
