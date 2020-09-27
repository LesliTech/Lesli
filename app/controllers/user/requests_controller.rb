class User::RequestsController < ApplicationController
  before_action :set_user_request, only: [:show, :edit, :update, :destroy]

  # GET /user/requests
  def index
    @user_requests = User::Request.all
  end

  # GET /user/requests/1
  def show
  end

  # GET /user/requests/new
  def new
    @user_request = User::Request.new
  end

  # GET /user/requests/1/edit
  def edit
  end

  # POST /user/requests
  def create
    @user_request = User::Request.new(user_request_params)

    if @user_request.save
      redirect_to @user_request, notice: 'Request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/requests/1
  def update
    if @user_request.update(user_request_params)
      redirect_to @user_request, notice: 'Request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/requests/1
  def destroy
    @user_request.destroy
    redirect_to user_requests_url, notice: 'Request was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_request
      @user_request = User::Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_request_params
      params.fetch(:user_request, {})
    end
end
