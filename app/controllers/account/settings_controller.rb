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

class Account::SettingsController < ApplicationLesliController
    before_action :set_account_setting, only: [:destroy]

    # GET /settings
    def index
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Account::Setting.index(current_user, @query))
            }
        end
    end

    # GET /settings/1
    def show
    end

    # GET /settings/security
    def security
    end

    # GET /settings/date_time
    def date_time
    end

    # GET /settings/branding
    def branding
    end

    # GET /settings/theme
    def theme
    end

    # POST /settings
    def create
        if params[:settings].blank?
            return respond_with_error(I18n.t("core.shared.messages_danger_settings_field_empty"))
        end

        params[:settings].each do |key, value|
            setting = current_user.account.settings.find_by(name: key)
            if setting.present?
                setting.update_attribute(:value, value)
            else
                current_user.account.settings.create!(name: key, value: value)
            end
        end

        respond_with_successful
    end

    # PATCH/PUT /settings/
    def update
        if params[:settings].blank?
            return respond_with_error(I18n.t("core.shared.messages_danger_settings_field_empty"))
        end

        setting = current_user.account.settings.find_by(name: params[:settings][:name])

        if setting.present?
            setting.update_attribute(:value, params[:settings][:value])
        else
            return respond_with_not_found
        end

        respond_with_successful
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

    def options
        respond_with_successful(current_user.account.settings.options(current_user, @query))
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



end
