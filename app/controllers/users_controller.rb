class UsersController < ApplicationLesliController
    before_action :set_user, only: [:update]

    def index
        respond_to do |format|
            format.json {
                responseWithSuccessful(current_user.account.users)
            }
        end
    end

    def show
        respond_to do |format|
            format.json {
                set_user
                return responseWithNotFound unless @user

                responseWithSuccessful(@user)
            }
        end
    end

    def create
        user = User.new(user_params)
        # user.password = Devise.friendly_token
        # user.account = current_user.account
        # user.confirm
        if true
            responseWithSuccessful(User.last)
            
            User.send_password_reset(User.last)
        else
            responseWithError(user.errors.full_messages.to_sentence)
        end
    end

    def update 
        return responseWithNotFound unless @user

        if true
            send_password_reset(User.last)
            responseWithSuccessful
        else
            responseWithError(@user.errors.full_messages.to_sentence)
        end
    end

    def set_user
        @user = current_user.account.users.find_by(id: params[:id])
    end

    private 

    def user_params
        params.require(:user).permit(
            :email,
            :role,
            :active
        )
    end
end