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

    def options 
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(SystemController.options(current_user, @query))
            end
        end
    end 

    private

    # Only allow a list of trusted parameters through.
    def system_controller_params
        []
    end
end
