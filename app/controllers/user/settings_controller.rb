=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class User::SettingsController < ApplicationLesliController
    before_action :set_user, only: [:create]
    before_action :set_user_setting, only: [:destroy]

    # GET /user/settings
    def index
        respond_with_successful(['hola'])
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

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = current_user.account.users.find_by_id(params[:user_id])
        @user = current_user unless @user
    end

    def set_user_setting
        @user_setting = @user.settings.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_setting_params
        params.require(:user_setting).permit(:name, :value)
    end
end
