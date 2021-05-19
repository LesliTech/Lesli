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

    # GET /settings
    def index
    end

    # GET /settings/1
    def show
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Account::Setting.list(current_user, @query))
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

    # PATCH/PUT /settings/
    def update
        if params[:settings].empty?
            return respond_with_not_found
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

    # Only allow a trusted parameter "white list" through.
    def setting_params
        params.require(:settings)
    end
    
end
