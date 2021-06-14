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
class SystemControllersController < ApplicationLesliController
    before_action :set_system_controller, only: [:show, :update, :destroy]

    # GET /system_controllers
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(SystemController.index(current_user, @query))
            end
        end
    end

    # GET /system_controllers/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @system_controller
                return respond_with_successful(@system_controller.show(current_user, @query))
            end
        end
    end

    # GET /system_controllers/new
    def new
    end

    # GET /system_controllers/1/edit
    def edit
    end

    # POST /system_controllers
    def create
        system_controller = SystemController.new(system_controller_params)
        if system_controller.save
            respond_with_successful(system_controller)
        else
            respond_with_error(system_controller.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /system_controllers/1
    def update
        return respond_with_not_found unless @system_controller

        if @system_controller.update(system_controller_params)
            respond_with_successful(@system_controller.show(current_user, @query))
        else
            respond_with_error(@system_controller.errors.full_messages.to_sentence)
        end
    end

    # DELETE /system_controllers/1
    def destroy
        return respond_with_not_found unless @system_controller

        if @system_controller.destroy
            respond_with_successful
        else
            respond_with_error(@system_controller.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_system_controller
        @system_controller = current_user.account.system_controllers.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def system_controller_params
        params.require(:system_controller).permit(:id, :name)
    end
end
