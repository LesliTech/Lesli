class Company::RolesController < ApplicationController
  before_action :set_company_role, only: [:show, :edit, :update, :destroy]

  # GET /company/roles
  def index
    @company_roles = Company::Role.all
  end

  # GET /company/roles/1
  def show
  end

  # GET /company/roles/new
  def new
    @company_role = Company::Role.new
  end

  # GET /company/roles/1/edit
  def edit
  end

  # POST /company/roles
  def create
    @company_role = Company::Role.new(company_role_params)

    if @company_role.save
      redirect_to @company_role, notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/roles/1
  def update
    if @company_role.update(company_role_params)
      redirect_to @company_role, notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/roles/1
  def destroy
    @company_role.destroy
    redirect_to company_roles_url, notice: 'Role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_role
      @company_role = Company::Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_role_params
      params.fetch(:company_role, {})
    end
end
