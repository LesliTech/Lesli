class UsersController < ApplicationLesliController
    before_action :set_user, only: [:show, :update]
    before_action :check_user_can_read_update, only: [:show, :update]

    def index
        respond_to do |format|
            format.html { }
            format.json {
                responseWithSuccessful(User.list(current_user, params[:role], params[:type], @query))
            }
        end
    end

    def show
        respond_to do |format|
            format.html {}
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

        # validate that user exists
        return responseWithNotFound unless @user

        params_user = user_params

        if not current_user.is_role?("owner", "admin")
            params_user.delete("roles_id")
            return responseWithUnauthorized
        end

        if @user.update(params_user)

            # delete user session
            #sign_out @user if @user.active == false

            # return a successful response 
            responseWithSuccessful
            
        else
            responseWithError(@user.errors.full_messages.to_sentence)
        end

    end

    def set_user
        @user = current_user.account.users.find_by(id: params[:id])
    end

    private 

    def check_user_can_read_update
        # Only admins can show the user information
        # If not admin, only the user can see his own information
        unless current_user.is_role?("owner", "admin") or current_user.id == @user.id
            return responseWithUnauthorized
        end
    end 
    
    def user_params
        params.require(:user).permit(
            :active,
            :roles_id,
            detail_attributes: [
                :first_name,
                :last_name,
                :title, 
                :salutation, 
                :telephone, 
                :address, 
                :work_city, 
                :work_region, 
                :work_address
            ]
        )
    end
    
end
