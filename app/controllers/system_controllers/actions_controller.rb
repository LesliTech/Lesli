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
class SystemControllers::ActionsController < ApplicationLesliController
    before_action :set_system_controllers_action, only: [:show, :update, :destroy]

    # GET /system_controllers/actions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(SystemControllers::Action.index(current_user, @query))
            end
        end
    end

    # GET /system_controllers/actions/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @system_controllers_action
                return respond_with_successful(@system_controllers_action.show(current_user, @query))
            end
        end
    end

    # GET /system_controllers/actions/new
    def new
    end

    # GET /system_controllers/actions/1/edit
    def edit
    end

    # POST /system_controllers/actions
    def create
        system_controllers_action = SystemControllers::Action.new(system_controllers_action_params)
        if system_controllers_action.save
            respond_with_successful(system_controllers_action)
        else
            respond_with_error(system_controllers_action.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /system_controllers/actions/1
    def update
        return respond_with_not_found unless @system_controllers_action

        if @system_controllers_action.update(system_controllers_action_params)
            respond_with_successful(@system_controllers_action.show(current_user, @query))
        else
            respond_with_error(@system_controllers_action.errors.full_messages.to_sentence)
        end
    end

    # DELETE /system_controllers/actions/1
    def destroy
        return respond_with_not_found unless @system_controllers_action

        if @system_controllers_action.destroy
            respond_with_successful
        else
            respond_with_error(@system_controllers_action.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_system_controllers_action
        @system_controllers_action = current_user.account.system_controllers_actions.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def system_controllers_action_params
        params.require(:system_controllers_action).permit(:id, :name)
    end
end
