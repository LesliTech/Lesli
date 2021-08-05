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
