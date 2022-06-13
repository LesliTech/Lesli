class User::SettingsController < ApplicationLesliController
    before_action :set_user, only: [:create]
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
        return respond_with_not_found unless @user
        
        settings = @user.settings.find_or_initialize_by(name: user_setting_params[:name])
        
        unless settings.update(user_setting_params)
            return respond_with_error(settings.errors.full_messages.to_sentence)
        end

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
    def set_user
        @user = current_user.account.users.find_by_id(params[:user_id])
        @user = current_user unless @user
    end

    def set_user_setting
        set_user

        @user_setting = @user.settings.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_setting_params
        params.require(:user_setting).permit(:name, :value, :value_numeric, :value_boolean)
    end
end
