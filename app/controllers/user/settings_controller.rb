class User::SettingsController < ApplicationLesliController
    before_action :set_user_setting, only: [:show, :edit, :update, :destroy]

    # GET /user/settings
    def index
        respond_with_successful(['hola'])
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
        settings = current_user.settings.find_or_initialize_by(name: user_setting_params[:name])
        settings.update(value: user_setting_params[:value])
        settings.save
        respond_with_successful(settings)
    end

    # PATCH/PUT /user/settings/1
    def update
        #if @user_setting.update(user_setting_params)
        respond_with_successful
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
        params.require(:user_setting).permit(:name, :value)
    end
end
