class Account::SettingsController < ApplicationLesliController
  before_action :set_account_setting, only: [:update, :destroy]

    # GET /settings
    def index
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Account::Setting.list(current_user, @query))
            }
        end
    end

    # GET /settings/1
    def show
        respond_to do |format|
            format.html {}
            format.json {
                set_account_setting
                return respond_with_successful unless @setting

                respond_with_successful(@setting)
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
        setting = Account::Setting.find_by(name: setting_params[:name])

        # update settings if exists
        if setting
            if setting.update(setting_params)
                respond_with_successful(setting)
            else
                respond_with_error("Error on create settings", setting.errors)
            end
        end
        
        # create settings if does not exist
        if setting.blank?
            setting = current_user.account.settings.new(setting_params)
            if setting.save
                respond_with_successful(setting)
            else
                respond_with_error("Error on create settings", setting.errors) 
            end
        end

        
    end

    # PATCH/PUT /settings/1
    def update
        return respond_with_not_found unless @setting

        if @setting.update(setting_params)
            if @setting.name.include?('date_format')
                LC::Date.reset_db_settings
            end
            respond_with_successful(@setting)
        else
            respond_with_error(@setting.error.full_messages.to_sentence)
        end
    end

    # DELETE /settings/1
    def destroy
        return respond_with_not_found unless @setting

        if @setting.destroy
            respond_with_successful
        else
            respond_with_error(@setting.error.full_messages.to_sentence)
        end

    end

    private

    # @return [void]
    # @description Sets the setting based on the current_users's account
    # @example
    #     # Executing this method from a controller action:
    #     set_account_setting
    #     puts @setting
    #     # This will either display nil or an instance of Account::Setting
    def set_account_setting
        @setting = current_user.account.settings.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
        params.require(:setting).permit(:name, :value)
    end
end
