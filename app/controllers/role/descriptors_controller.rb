=begin
Copyright (c) 2023, all rights reserved.

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
class Role::DescriptorsController < ApplicationController
    before_action :set_role_descriptor, only: [:show, :update, :destroy]

    # GET /role/descriptors
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Role::Descriptor.index(current_user, @query))
            end
        end
    end

    # GET /role/descriptors/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_descriptor
                return respond_with_successful(@role_descriptor.show(current_user, @query))
            end
        end
    end

    # GET /role/descriptors/new
    def new
    end

    # GET /role/descriptors/1/edit
    def edit
    end

    # POST /role/descriptors
    def create
        role_descriptor = Role::Descriptor.new(role_descriptor_params)
        if role_descriptor.save
            respond_with_successful(role_descriptor)
        else
            respond_with_error(role_descriptor.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /role/descriptors/1
    def update
        return respond_with_not_found unless @role_descriptor

        if @role_descriptor.update(role_descriptor_params)
            respond_with_successful(@role_descriptor.show(current_user, @query))
        else
            respond_with_error(@role_descriptor.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/descriptors/1
    def destroy
        return respond_with_not_found unless @role_descriptor

        if @role_descriptor.destroy
            respond_with_successful
        else
            respond_with_error(@role_descriptor.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_descriptor
        @role_descriptor = current_user.account.role_descriptors.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_descriptor_params
        params.require(:role_descriptor).permit(:id, :name)
    end
end
