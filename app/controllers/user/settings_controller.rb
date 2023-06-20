=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
