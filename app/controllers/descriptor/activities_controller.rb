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
class Descriptor::ActivitiesController < ApplicationController
    before_action :set_descriptor_activity, only: []

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor_activity
    end

    # Only allow a list of trusted parameters through.
    def descriptor_activity_params
    end
end
