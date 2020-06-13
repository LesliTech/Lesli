class User::SettingsController < ApplicationController
  before_action :set_user_setting, only: [:show, :edit, :update, :destroy]

  # GET /user/settings
  def index
    @user_settings = User::Setting.all
  end

  # GET /user/settings/1
  def show
  end

  # GET /user/settings/new
  def new
    @user_setting = User::Setting.new
  end

  # GET /user/settings/1/edit
  def edit
  end

  # POST /user/settings
  def create
    @user_setting = User::Setting.new(user_setting_params)

    if @user_setting.save
      redirect_to @user_setting, notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/settings/1
  def update
    if @user_setting.update(user_setting_params)
      redirect_to @user_setting, notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/settings/1
  def destroy
    @user_setting.destroy
    redirect_to user_settings_url, notice: 'Setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_setting
      @user_setting = User::Setting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_setting_params
      params.fetch(:user_setting, {})
    end
end
