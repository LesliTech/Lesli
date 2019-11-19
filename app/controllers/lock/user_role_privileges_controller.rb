class Lock::UserRolePrivilegesController < ApplicationController
  before_action :set_lock_user_role_privilege, only: [:show, :edit, :update, :destroy]

  # GET /lock/user_role_privileges
  def index
    @lock_user_role_privileges = Lock::UserRolePrivilege.all
  end

  # GET /lock/user_role_privileges/1
  def show
  end

  # GET /lock/user_role_privileges/new
  def new
    @lock_user_role_privilege = Lock::UserRolePrivilege.new
  end

  # GET /lock/user_role_privileges/1/edit
  def edit
  end

  # POST /lock/user_role_privileges
  def create
    @lock_user_role_privilege = Lock::UserRolePrivilege.new(lock_user_role_privilege_params)

    if @lock_user_role_privilege.save
      redirect_to @lock_user_role_privilege, notice: 'User role privilege was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/user_role_privileges/1
  def update
    if @lock_user_role_privilege.update(lock_user_role_privilege_params)
      redirect_to @lock_user_role_privilege, notice: 'User role privilege was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/user_role_privileges/1
  def destroy
    @lock_user_role_privilege.destroy
    redirect_to lock_user_role_privileges_url, notice: 'User role privilege was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_user_role_privilege
      @lock_user_role_privilege = Lock::UserRolePrivilege.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_user_role_privilege_params
      params.fetch(:lock_user_role_privilege, {})
    end
end
