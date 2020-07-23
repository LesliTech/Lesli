class UsersController < ApplicationLesliController
    before_action :set_user, only: [:show, :update]
    def index
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_successful(User.list(current_user, params[:role], params[:type], @query))
            }
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json {
                return respond_with_not_found unless @user
                return respond_with_unauthorized unless @user.is_editable_by?(current_user)

                respond_with_successful(@user.show(current_user))
            }
        end
    end

    def create
        user = User.new(user_params)
        user.password = Devise.friendly_token
        user.account = current_user.account
        user.confirm

        if user.save
            respond_with_successful(user)
            User.send_password_reset(user)
        else
            respond_with_error(user.errors.full_messages.to_sentence)
        end
    end

    def update 

        # validate that user exists
        return respond_with_not_found unless @user
        return respond_with_unauthorized unless @user.is_editable_by?(current_user)

        params_user = user_params

        if params_user["roles_id"]
            role_name = Role.find(params_user["roles_id"]).detail.name
            return responseWithUnauthorized if role_name == "owner" && !current_user.is_role?("owner")
        end

        params_user.delete("roles_id") if not current_user.is_role?("owner", "admin")

        if @user.update(params_user)

            # delete user session
            #sign_out @user if @user.active == false

            # return a successful response 
            respond_with_successful
            
        else
            respond_with_error(@user.errors.full_messages.to_sentence)
        end

    end

    def set_user
        @user = current_user.account.users.find_by(id: params[:id])
    end

    def options
        options = {
            roles: current_user.account.roles.joins(:detail)
                    .select("
                        roles.id as value, 
                        role_details.name as text
                    "),
            salutations: User::Detail.salutations.map {|k, v| {value: k, text: v}},
        }

        respond_with_successful(options)
    end

    private
    
    def user_params
        params.require(:user).permit(
            :email,
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
