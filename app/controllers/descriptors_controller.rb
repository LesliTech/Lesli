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

class DescriptorsController < ApplicationLesliController
    before_action :set_descriptor, only: [:show]

    def privileges 
        {
            list: [],
            index: [],
            show: []
        }
    end

    # GET /descriptors/list.json
    def list
        respond_with_successful(Descriptor.list(current_user, @query))
    end

    # GET /descriptors
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(Descriptor.index(current_user, @query))
            end
        end
    end

    # GET /descriptors/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @descriptor
                return respond_with_successful(@descriptor.show(current_user, @query))
            end
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor
        @descriptor = current_user.account.descriptors.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def descriptor_params
        params.require(:descriptor).permit(:id, :name)
    end
end
