class User::DetailsController < ApplicationController
  before_action :set_user_detail, only: [:show, :edit, :update, :destroy]

  # GET /user/details
  def index
    @user_details = User::Detail.all
  end

  # GET /user/details/1
  def show
  end

  # GET /user/details/new
  def new
    @user_detail = User::Detail.new
  end

  # GET /user/details/1/edit
  def edit
  end

  # POST /user/details
  def create
    @user_detail = User::Detail.new(user_detail_params)

    if @user_detail.save
      redirect_to @user_detail, notice: 'Detail was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/details/1
  def update
    if @user_detail.update(user_detail_params)
      redirect_to @user_detail, notice: 'Detail was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/details/1
  def destroy
    @user_detail.destroy
    redirect_to user_details_url, notice: 'Detail was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_detail
      @user_detail = User::Detail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_detail_params
        params.fetch(:user_detail, {})
    end
end
