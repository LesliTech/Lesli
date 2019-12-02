class UsersController < ApplicationLesliController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

    # GET /Users
    def index
        users = current_user.account.users
            .left_joins(:detail)
            .select(:id, :first_name, :last_name, :email)
            .order(:id)
        respond_to do |format|
            format.html {  }
            format.json { responseWithSuccessful(users) }
        end
    end

  # GET /Users/1
  def show
    user = current_user.account.users
        .joins(:detail)
        .select( 
            :id, :first_name, :last_name, :telephone, :address
        ).find(@user.id)
    respond_to do |format|  
        format.html {  }
        format.json { 
            responseWithSuccessful({
                id: user[:id],
                detail_attributes: {
                    id: user[:id],
                    first_name: user[:first_name],
                    last_name: user[:last_name],
                    telephone: user[:telephone],
                    address: user[:address]
                }
            }) 
        }
    end
end

    # GET /Users/new
    def new
    end

  # GET /Users/1/edit
  def edit
  end

    # POST /Users
    def create

        generated_password = Devise.friendly_token.first(64)

        @user = User.new(user_params)

        @user.password = generated_password
        @user.password_confirmation = generated_password
        @user.accounts_id = current_user.account.id
        @user.confirm

        if @user.save
            responseWithSuccessful(@user)
        else
            responseWithError("error creating user", @user.errors.full_messages)
        end

    end

  # PATCH/PUT /Users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'user was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /Users/1
  def destroy
    @user.destroy
    redirect_to Users_url, notice: 'user was successfully destroyed.'
  end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user

        user_id = params[:id] unless params[:id].blank?
        user_id = params[:user_id] unless params[:user_id].blank?
        @user = User.find(params[:id])

    end

    # Only allow a trusted parameter "white list" through.
    def user_params
        params.require(:user).permit(
            :id,
            :email,
            :password,
            :password_confirmation,
            :created_at, 
            detail_attributes: [
                :id,
                :first_name,
                :last_name,
                :telephone,
                :address
            ]
        )
    end

end
