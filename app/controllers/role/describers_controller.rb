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
class Role::DescribersController < ApplicationController
    before_action :set_role_describer, only: [:show, :update, :destroy]

    # GET /role/describers
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Role::Describer.index(current_user, @query))
            end
        end
    end

    # GET /role/describers/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_describer
                return respond_with_successful(@role_describer.show(current_user, @query))
            end
        end
    end

    # GET /role/describers/new
    def new
    end

    # GET /role/describers/1/edit
    def edit
    end

    # POST /role/describers
    def create
        role_describer = Role::Describer.new(role_describer_params)
        if role_describer.save
            respond_with_successful(role_describer)
        else
            respond_with_error(role_describer.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /role/describers/1
    def update
        return respond_with_not_found unless @role_describer

        if @role_describer.update(role_describer_params)
            respond_with_successful(@role_describer.show(current_user, @query))
        else
            respond_with_error(@role_describer.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/describers/1
    def destroy
        return respond_with_not_found unless @role_describer

        if @role_describer.destroy
            respond_with_successful
        else
            respond_with_error(@role_describer.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_describer
        @role_describer = current_user.account.role_describers.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_describer_params
        params.require(:role_describer).permit(:id, :name)
    end
end
