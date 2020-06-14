class Role::DetailsController < ApplicationController
  before_action :set_role_detail, only: [:show, :edit, :update, :destroy]

  # GET /role/details
  def index
    @role_details = Role::Detail.all
  end

  # GET /role/details/1
  def show
  end

  # GET /role/details/new
  def new
    @role_detail = Role::Detail.new
  end

  # GET /role/details/1/edit
  def edit
  end

  # POST /role/details
  def create
    @role_detail = Role::Detail.new(role_detail_params)

    if @role_detail.save
      redirect_to @role_detail, notice: 'Detail was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /role/details/1
  def update
    if @role_detail.update(role_detail_params)
      redirect_to @role_detail, notice: 'Detail was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /role/details/1
  def destroy
    @role_detail.destroy
    redirect_to role_details_url, notice: 'Detail was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role_detail
      @role_detail = Role::Detail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_detail_params
      params.fetch(:role_detail, {})
    end
end
