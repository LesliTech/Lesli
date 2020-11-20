class User::RolesController < ApplicationController
  before_action :set_user_role, only: [:show, :edit, :update, :destroy]

  # GET /user/roles
  def index
    @user_roles = User::Role.all
  end

  # GET /user/roles/1
  def show
  end

  # GET /user/roles/new
  def new
    @user_role = User::Role.new
  end

  # GET /user/roles/1/edit
  def edit
  end

  # POST /user/roles
  def create
    @user_role = User::Role.new(user_role_params)

    if @user_role.save
      redirect_to @user_role, notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/roles/1
  def update
    if @user_role.update(user_role_params)
      redirect_to @user_role, notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/roles/1
  def destroy
    @user_role.destroy
    redirect_to user_roles_url, notice: 'Role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_role
      @user_role = User::Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_role_params
      params.fetch(:user_role, {})
    end
end
