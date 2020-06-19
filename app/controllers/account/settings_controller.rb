class Account::SettingsController < ApplicationController
  before_action :set_account_setting, only: [:show, :edit, :update, :destroy]

    # GET /settings
    def index
        respond_to do |format|
            format.html {}
            format.json {
                responseWithSuccessful(Account::Setting.list(current_user, @query))
            }
        end
    end

    # GET /settings/1
    def show
        respond_to do |format|
            format.json {
                responseWithSuccessful(@setting)
            }
        end
    end

    # GET /settings/new
    def new
    end

    # GET /settings/1/edit
    def edit
    end

    # POST /settings
    def create

        # check if setting exists
        setting = Setting.find_by(name: setting_params[:name])

        # update settings if exists
        if setting
            if setting.update(setting_params)
                responseWithSuccessful(setting)
            else
                responseWithError("Error on create settings", setting.errors)
            end
        end
        
        # create settings if does not exist
        if setting.blank?
            setting = current_user.account.settings.new(setting_params)
            if setting.save
                responseWithSuccessful(setting)
            else
                responseWithError("Error on create settings", setting.errors) 
            end
        end

        
    end

    # PATCH/PUT /settings/1
    def update
        return responseWithNotFound unless @setting

        if @setting.update(setting_params)
            if @setting.name.include?('date_format')
                LC::Date.reset_db_settings
            end
            responseWithSuccessful(@setting)
        else
            responseWithError(@setting.error.full_messages.to_sentence)
        end
    end

    # DELETE /settings/1
    def destroy

    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
        @setting = Setting.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
        params.require(:setting).permit(:name, :value)
    end
end
