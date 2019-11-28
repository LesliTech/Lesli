class UsersController < ApplicationLesliController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

    # GET /Users
    def index
        users = current_user.account.users
            .left_joins(:detail)
            .order(:id)
        respond_to do |format|
            format.html {  }
            format.json { responseWithSuccessful(users) }
        end
    end

  # GET /Users/1
  def show
  end

  # GET /Users/new
  def new
    @user = User.new
  end

  # GET /Users/1/edit
  def edit
  end

  # POST /Users
  def create

    @user = User.new(user_params)
    if @user.save
        responseWithSuccessful(@user)
    else
        responseWithError("error creating employee", @user.errors.full_messages)
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
      @user = user.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
        params.require(:user).permit(
            :id,
            :email,
            :password,
            :created_at, 
            detail_attributes: [
                :id,
                :name
            ]
        )
    end
end
