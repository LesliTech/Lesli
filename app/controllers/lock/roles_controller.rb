class Lock::RolesController < ApplicationController
  before_action :set_lock_role, only: [:show, :edit, :update, :destroy]

  # GET /lock/roles
  def index
    @lock_roles = Lock::Role.all
  end

  # GET /lock/roles/1
  def show
  end

  # GET /lock/roles/new
  def new
    @lock_role = Lock::Role.new
  end

  # GET /lock/roles/1/edit
  def edit
  end

  # POST /lock/roles
  def create
    @lock_role = Lock::Role.new(lock_role_params)

    if @lock_role.save
      redirect_to @lock_role, notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/roles/1
  def update
    if @lock_role.update(lock_role_params)
      redirect_to @lock_role, notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/roles/1
  def destroy
    @lock_role.destroy
    redirect_to lock_roles_url, notice: 'Role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_role
      @lock_role = Lock::Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_role_params
      params.fetch(:lock_role, {})
    end
end
