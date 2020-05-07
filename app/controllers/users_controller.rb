class UsersController < ApplicationLesliController
    before_action :set_user, only: [:update]

    def index
        respond_to do |format|
            format.json {
            
                users = User.index(current_user, params[:role])

                responseWithSuccessful(users)

            }
        end
    end

    def show
        respond_to do |format|
            format.json {
                set_user
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

    private 

    def user_params
        params.require(:user).permit(
            :name,
            :email,
            :role,
            :active
        )
    end
end
