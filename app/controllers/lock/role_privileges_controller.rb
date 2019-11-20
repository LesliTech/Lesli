class Lock::RolePrivilegesController < ApplicationController
  before_action :set_lock_role_privilege, only: [:show, :edit, :update, :destroy]

  # GET /lock/role_privileges
  def index
    @lock_role_privileges = Lock::RolePrivilege.all
  end

  # GET /lock/role_privileges/1
  def show
  end

  # GET /lock/role_privileges/new
  def new
    @lock_role_privilege = Lock::RolePrivilege.new
  end

  # GET /lock/role_privileges/1/edit
  def edit
  end

  # POST /lock/role_privileges
  def create
    @lock_role_privilege = Lock::RolePrivilege.new(lock_role_privilege_params)

    if @lock_role_privilege.save
      redirect_to @lock_role_privilege, notice: 'Role privilege was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/role_privileges/1
  def update
    if @lock_role_privilege.update(lock_role_privilege_params)
      redirect_to @lock_role_privilege, notice: 'Role privilege was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/role_privileges/1
  def destroy
    @lock_role_privilege.destroy
    redirect_to lock_role_privileges_url, notice: 'Role privilege was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_role_privilege
      @lock_role_privilege = Lock::RolePrivilege.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_role_privilege_params
      params.fetch(:lock_role_privilege, {})
    end
end
