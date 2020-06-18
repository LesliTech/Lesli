class Roles::PrivilegeDefaultsController < ApplicationController
  before_action :set_roles_privilege_default, only: [:show, :edit, :update, :destroy]

  # GET /roles/privilege_defaults
  def index
    @roles_privilege_defaults = Roles::PrivilegeDefault.all
  end

  # GET /roles/privilege_defaults/1
  def show
  end

  # GET /roles/privilege_defaults/new
  def new
    @roles_privilege_default = Roles::PrivilegeDefault.new
  end

  # GET /roles/privilege_defaults/1/edit
  def edit
  end

  # POST /roles/privilege_defaults
  def create
    @roles_privilege_default = Roles::PrivilegeDefault.new(roles_privilege_default_params)

    if @roles_privilege_default.save
      redirect_to @roles_privilege_default, notice: 'Privilege default was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /roles/privilege_defaults/1
  def update
    if @roles_privilege_default.update(roles_privilege_default_params)
      redirect_to @roles_privilege_default, notice: 'Privilege default was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /roles/privilege_defaults/1
  def destroy
    @roles_privilege_default.destroy
    redirect_to roles_privilege_defaults_url, notice: 'Privilege default was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roles_privilege_default
      @roles_privilege_default = Roles::PrivilegeDefault.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def roles_privilege_default_params
      params.fetch(:roles_privilege_default, {})
    end
end
