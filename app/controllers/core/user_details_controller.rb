class Core::UserDetailsController < ApplicationController
  before_action :set_core_user_detail, only: [:show, :edit, :update, :destroy]

  # GET /core/user_details
  def index
    @core_user_details = Core::UserDetail.all
  end

  # GET /core/user_details/1
  def show
  end

  # GET /core/user_details/new
  def new
    @core_user_detail = Core::UserDetail.new
  end

  # GET /core/user_details/1/edit
  def edit
  end

  # POST /core/user_details
  def create
    @core_user_detail = Core::UserDetail.new(core_user_detail_params)

    if @core_user_detail.save
      redirect_to @core_user_detail, notice: 'User detail was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /core/user_details/1
  def update
    if @core_user_detail.update(core_user_detail_params)
      redirect_to @core_user_detail, notice: 'User detail was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /core/user_details/1
  def destroy
    @core_user_detail.destroy
    redirect_to core_user_details_url, notice: 'User detail was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_user_detail
      @core_user_detail = Core::UserDetail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_user_detail_params
      params.fetch(:core_user_detail, {})
    end
end
