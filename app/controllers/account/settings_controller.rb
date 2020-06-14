class Account::SettingsController < ApplicationController
  before_action :set_account_setting, only: [:show, :edit, :update, :destroy]

  # GET /account/settings
  def index
    @account_settings = Account::Setting.all
  end

  # GET /account/settings/1
  def show
  end

  # GET /account/settings/new
  def new
    @account_setting = Account::Setting.new
  end

  # GET /account/settings/1/edit
  def edit
  end

  # POST /account/settings
  def create
    @account_setting = Account::Setting.new(account_setting_params)

    if @account_setting.save
      redirect_to @account_setting, notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /account/settings/1
  def update
    if @account_setting.update(account_setting_params)
      redirect_to @account_setting, notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /account/settings/1
  def destroy
    @account_setting.destroy
    redirect_to account_settings_url, notice: 'Setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_setting
      @account_setting = Account::Setting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_setting_params
      params.fetch(:account_setting, {})
    end
end
