class User::LogsController < ApplicationController
  before_action :set_user_log, only: [:show, :edit, :update, :destroy]

  # GET /user/logs
  def index
    @user_logs = User::Log.all
  end

  # GET /user/logs/1
  def show
  end

  # GET /user/logs/new
  def new
    @user_log = User::Log.new
  end

  # GET /user/logs/1/edit
  def edit
  end

  # POST /user/logs
  def create
    @user_log = User::Log.new(user_log_params)

    if @user_log.save
      redirect_to @user_log, notice: 'Log was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/logs/1
  def update
    if @user_log.update(user_log_params)
      redirect_to @user_log, notice: 'Log was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/logs/1
  def destroy
    @user_log.destroy
    redirect_to user_logs_url, notice: 'Log was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_log
      @user_log = User::Log.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_log_params
      params.fetch(:user_log, {})
    end
end
