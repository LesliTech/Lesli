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
class DescriptorsController < ApplicationController
    before_action :set_descriptor, only: [:show, :update, :destroy]

    # GET /descriptors
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Descriptor.index(current_user, @query))
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

    # GET /descriptors/new
    def new
    end

    # GET /descriptors/1/edit
    def edit
    end

    # POST /descriptors
    def create
        descriptor = Descriptor.new(descriptor_params)
        if descriptor.save
            respond_with_successful(descriptor)
        else
            respond_with_error(descriptor.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /descriptors/1
    def update
        return respond_with_not_found unless @descriptor

        if @descriptor.update(descriptor_params)
            respond_with_successful(@descriptor.show(current_user, @query))
        else
            respond_with_error(@descriptor.errors.full_messages.to_sentence)
        end
    end

    # DELETE /descriptors/1
    def destroy
        return respond_with_not_found unless @descriptor

        if @descriptor.destroy
            respond_with_successful
        else
            respond_with_error(@descriptor.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor
        @descriptor = current_user.account.descriptors.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def descriptor_params
        params.require(:descriptor).permit(:id, :name)
    end
end
