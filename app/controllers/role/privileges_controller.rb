class Role::PrivilegesController < ApplicationController
  before_action :set_role_privilege, only: [:show, :edit, :update, :destroy]

  # GET /role/privileges
  def index
    @role_privileges = Role::Privilege.all
  end

  # GET /role/privileges/1
  def show
  end

  # GET /role/privileges/new
  def new
    @role_privilege = Role::Privilege.new
  end

  # GET /role/privileges/1/edit
  def edit
  end

  # POST /role/privileges
  def create
    @role_privilege = Role::Privilege.new(role_privilege_params)

    if @role_privilege.save
      redirect_to @role_privilege, notice: 'Privilege was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /role/privileges/1
  def update
    if @role_privilege.update(role_privilege_params)
      redirect_to @role_privilege, notice: 'Privilege was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /role/privileges/1
  def destroy
    @role_privilege.destroy
    redirect_to role_privileges_url, notice: 'Privilege was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role_privilege
      @role_privilege = Role::Privilege.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_privilege_params
      params.fetch(:role_privilege, {})
    end
end
