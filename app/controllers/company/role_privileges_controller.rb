class Company::RolePrivilegesController < ApplicationController
  before_action :set_company_role_privilege, only: [:show, :edit, :update, :destroy]

  # GET /company/role_privileges
  def index
    @company_role_privileges = Company::RolePrivilege.all
  end

  # GET /company/role_privileges/1
  def show
  end

  # GET /company/role_privileges/new
  def new
    @company_role_privilege = Company::RolePrivilege.new
  end

  # GET /company/role_privileges/1/edit
  def edit
  end

  # POST /company/role_privileges
  def create
    @company_role_privilege = Company::RolePrivilege.new(company_role_privilege_params)

    if @company_role_privilege.save
      redirect_to @company_role_privilege, notice: 'Role privilege was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/role_privileges/1
  def update
    if @company_role_privilege.update(company_role_privilege_params)
      redirect_to @company_role_privilege, notice: 'Role privilege was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/role_privileges/1
  def destroy
    @company_role_privilege.destroy
    redirect_to company_role_privileges_url, notice: 'Role privilege was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_role_privilege
      @company_role_privilege = Company::RolePrivilege.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_role_privilege_params
      params.fetch(:company_role_privilege, {})
    end
end
