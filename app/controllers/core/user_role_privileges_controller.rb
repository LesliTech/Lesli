class Core::UserRolePrivilegesController < ApplicationController
  before_action :set_core_user_role_privilege, only: [:show, :edit, :update, :destroy]

  # GET /core/user_role_privileges
  def index
    @core_user_role_privileges = Core::UserRolePrivilege.all
  end

  # GET /core/user_role_privileges/1
  def show
  end

  # GET /core/user_role_privileges/new
  def new
    @core_user_role_privilege = Core::UserRolePrivilege.new
  end

  # GET /core/user_role_privileges/1/edit
  def edit
  end

  # POST /core/user_role_privileges
  def create
    @core_user_role_privilege = Core::UserRolePrivilege.new(core_user_role_privilege_params)

    if @core_user_role_privilege.save
      redirect_to @core_user_role_privilege, notice: 'User role privilege was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /core/user_role_privileges/1
  def update
    if @core_user_role_privilege.update(core_user_role_privilege_params)
      redirect_to @core_user_role_privilege, notice: 'User role privilege was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /core/user_role_privileges/1
  def destroy
    @core_user_role_privilege.destroy
    redirect_to core_user_role_privileges_url, notice: 'User role privilege was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_user_role_privilege
      @core_user_role_privilege = Core::UserRolePrivilege.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_user_role_privilege_params
      params.fetch(:core_user_role_privilege, {})
    end
end
