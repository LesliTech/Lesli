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
class Descriptor::PrivilegesController < ApplicationController
    before_action :set_descriptor_privilege, only: [:show, :update, :destroy]

    # GET /descriptor/privileges
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Descriptor::Privilege.index(current_user, @query))
            end
        end
    end

    # GET /descriptor/privileges/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @descriptor_privilege
                return respond_with_successful(@descriptor_privilege.show(current_user, @query))
            end
        end
    end

    # GET /descriptor/privileges/new
    def new
    end

    # GET /descriptor/privileges/1/edit
    def edit
    end

    # POST /descriptor/privileges
    def create
        descriptor_privilege = Descriptor::Privilege.new(descriptor_privilege_params)
        if descriptor_privilege.save
            respond_with_successful(descriptor_privilege)
        else
            respond_with_error(descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /descriptor/privileges/1
    def update
        return respond_with_not_found unless @descriptor_privilege

        if @descriptor_privilege.update(descriptor_privilege_params)
            respond_with_successful(@descriptor_privilege.show(current_user, @query))
        else
            respond_with_error(@descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # DELETE /descriptor/privileges/1
    def destroy
        return respond_with_not_found unless @descriptor_privilege

        if @descriptor_privilege.destroy
            respond_with_successful
        else
            respond_with_error(@descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor_privilege
        @descriptor_privilege = current_user.account.descriptor_privileges.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def descriptor_privilege_params
        params.require(:descriptor_privilege).permit(:id, :name)
    end
end
