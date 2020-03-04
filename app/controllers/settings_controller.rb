=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
class SettingsController < ApplicationController
    before_action :set_setting, only: [:show, :edit, :update, :destroy]

    # GET /settings
    def index
        
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

    end

    # DELETE /settings/1
    def destroy

    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
        @setting = Setting.find_by(name: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
        params.require(:setting).permit(:name, :value)
    end
end
