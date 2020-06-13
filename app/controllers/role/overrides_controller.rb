class Role::OverridesController < ApplicationController
  before_action :set_role_override, only: [:show, :edit, :update, :destroy]

  # GET /role/overrides
  def index
    @role_overrides = Role::Override.all
  end

  # GET /role/overrides/1
  def show
  end

  # GET /role/overrides/new
  def new
    @role_override = Role::Override.new
  end

  # GET /role/overrides/1/edit
  def edit
  end

  # POST /role/overrides
  def create
    @role_override = Role::Override.new(role_override_params)

    if @role_override.save
      redirect_to @role_override, notice: 'Override was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /role/overrides/1
  def update
    if @role_override.update(role_override_params)
      redirect_to @role_override, notice: 'Override was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /role/overrides/1
  def destroy
    @role_override.destroy
    redirect_to role_overrides_url, notice: 'Override was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role_override
      @role_override = Role::Override.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_override_params
      params.fetch(:role_override, {})
    end
end
