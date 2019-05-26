class Core::AccountDetailsController < ApplicationController
  before_action :set_core_account_detail, only: [:show, :edit, :update, :destroy]

  # GET /core/account_details
  def index
    @core_account_details = Core::AccountDetail.all
  end

  # GET /core/account_details/1
  def show
  end

  # GET /core/account_details/new
  def new
    @core_account_detail = Core::AccountDetail.new
  end

  # GET /core/account_details/1/edit
  def edit
  end

  # POST /core/account_details
  def create
    @core_account_detail = Core::AccountDetail.new(core_account_detail_params)

    if @core_account_detail.save
      redirect_to @core_account_detail, notice: 'Account detail was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /core/account_details/1
  def update
    if @core_account_detail.update(core_account_detail_params)
      redirect_to @core_account_detail, notice: 'Account detail was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /core/account_details/1
  def destroy
    @core_account_detail.destroy
    redirect_to core_account_details_url, notice: 'Account detail was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_account_detail
      @core_account_detail = Core::AccountDetail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_account_detail_params
      params.fetch(:core_account_detail, {})
    end
end
