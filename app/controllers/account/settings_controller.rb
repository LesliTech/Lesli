=begin

Copyright (c) 2021, all rights reserved.

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

class Account::SettingsController < ApplicationLesliController
    before_action :set_account_setting, only: [:destroy]

    def privileges 
        {
            index: [],
            security: [],
            date_time: [],
            branding: [],
            theme: []
        }
    end 

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
