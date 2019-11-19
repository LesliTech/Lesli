class Lock::UserRolesController < ApplicationController
  before_action :set_lock_user_role, only: [:show, :edit, :update, :destroy]

  # GET /lock/user_roles
  def index
    @lock_user_roles = Lock::UserRole.all
  end

  # GET /lock/user_roles/1
  def show
  end

  # GET /lock/user_roles/new
  def new
    @lock_user_role = Lock::UserRole.new
  end

  # GET /lock/user_roles/1/edit
  def edit
  end

  # POST /lock/user_roles
  def create
    @lock_user_role = Lock::UserRole.new(lock_user_role_params)

    if @lock_user_role.save
      redirect_to @lock_user_role, notice: 'User role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/user_roles/1
  def update
    if @lock_user_role.update(lock_user_role_params)
      redirect_to @lock_user_role, notice: 'User role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/user_roles/1
  def destroy
    @lock_user_role.destroy
    redirect_to lock_user_roles_url, notice: 'User role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_user_role
      @lock_user_role = Lock::UserRole.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_user_role_params
      params.fetch(:lock_user_role, {})
    end
end
