class Lock::RoleOverridesController < ApplicationController
  before_action :set_lock_role_override, only: [:show, :edit, :update, :destroy]

  # GET /lock/role_overrides
  def index
    @lock_role_overrides = Lock::RoleOverride.all
  end

  # GET /lock/role_overrides/1
  def show
  end

  # GET /lock/role_overrides/new
  def new
    @lock_role_override = Lock::RoleOverride.new
  end

  # GET /lock/role_overrides/1/edit
  def edit
  end

  # POST /lock/role_overrides
  def create
    @lock_role_override = Lock::RoleOverride.new(lock_role_override_params)

    if @lock_role_override.save
      redirect_to @lock_role_override, notice: 'Role override was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/role_overrides/1
  def update
    if @lock_role_override.update(lock_role_override_params)
      redirect_to @lock_role_override, notice: 'Role override was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/role_overrides/1
  def destroy
    @lock_role_override.destroy
    redirect_to lock_role_overrides_url, notice: 'Role override was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_role_override
      @lock_role_override = Lock::RoleOverride.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_role_override_params
      params.fetch(:lock_role_override, {})
    end
end
