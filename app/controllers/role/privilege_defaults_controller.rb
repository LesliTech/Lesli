class Role::PrivilegeDefaultsController < ApplicationController
  before_action :set_role_privilege_default, only: [:show, :edit, :update, :destroy]

  # GET /role/privilege_defaults
  def index
    @role_privilege_defaults = Role::PrivilegeDefault.all
  end

  # GET /role/privilege_defaults/1
  def show
  end

  # GET /role/privilege_defaults/new
  def new
    @role_privilege_default = Role::PrivilegeDefault.new
  end

  # GET /role/privilege_defaults/1/edit
  def edit
  end

  # POST /role/privilege_defaults
  def create
    @role_privilege_default = Role::PrivilegeDefault.new(role_privilege_default_params)

    if @role_privilege_default.save
      redirect_to @role_privilege_default, notice: 'Privilege default was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /role/privilege_defaults/1
  def update
    if @role_privilege_default.update(role_privilege_default_params)
      redirect_to @role_privilege_default, notice: 'Privilege default was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /role/privilege_defaults/1
  def destroy
    @role_privilege_default.destroy
    redirect_to role_privilege_defaults_url, notice: 'Privilege default was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role_privilege_default
      @role_privilege_default = Role::PrivilegeDefault.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_privilege_default_params
      params.fetch(:role_privilege_default, {})
    end
end
