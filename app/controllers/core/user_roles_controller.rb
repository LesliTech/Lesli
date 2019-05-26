class Core::UserRolesController < ApplicationController
  before_action :set_core_user_role, only: [:show, :edit, :update, :destroy]

  # GET /core/user_roles
  def index
    @core_user_roles = Core::UserRole.all
  end

  # GET /core/user_roles/1
  def show
  end

  # GET /core/user_roles/new
  def new
    @core_user_role = Core::UserRole.new
  end

  # GET /core/user_roles/1/edit
  def edit
  end

  # POST /core/user_roles
  def create
    @core_user_role = Core::UserRole.new(core_user_role_params)

    if @core_user_role.save
      redirect_to @core_user_role, notice: 'User role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /core/user_roles/1
  def update
    if @core_user_role.update(core_user_role_params)
      redirect_to @core_user_role, notice: 'User role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /core/user_roles/1
  def destroy
    @core_user_role.destroy
    redirect_to core_user_roles_url, notice: 'User role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_user_role
      @core_user_role = Core::UserRole.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_user_role_params
      params.fetch(:core_user_role, {})
    end
end
