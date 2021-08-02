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
class RoleDescriptor::ActivitiesController < ApplicationLesliController
    before_action :set_role_descriptor_activity, only: [:show, :update, :destroy]

    # GET /role_descriptor/activities
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(RoleDescriptor::Activity.index(current_user, @query))
            end
        end
    end

    # GET /role_descriptor/activities/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_descriptor_activity
                return respond_with_successful(@role_descriptor_activity.show(current_user, @query))
            end
        end
    end

    # GET /role_descriptor/activities/new
    def new
    end

    # GET /role_descriptor/activities/1/edit
    def edit
    end

    # POST /role_descriptor/activities
    def create
        role_descriptor_activity = RoleDescriptor::Activity.new(role_descriptor_activity_params)
        if role_descriptor_activity.save
            respond_with_successful(role_descriptor_activity)
        else
            respond_with_error(role_descriptor_activity.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /role_descriptor/activities/1
    def update
        return respond_with_not_found unless @role_descriptor_activity

        if @role_descriptor_activity.update(role_descriptor_activity_params)
            respond_with_successful(@role_descriptor_activity.show(current_user, @query))
        else
            respond_with_error(@role_descriptor_activity.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role_descriptor/activities/1
    def destroy
        return respond_with_not_found unless @role_descriptor_activity

        if @role_descriptor_activity.destroy
            respond_with_successful
        else
            respond_with_error(@role_descriptor_activity.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_descriptor_activity
        @role_descriptor_activity = current_user.account.role_descriptor_activities.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_descriptor_activity_params
        params.require(:role_descriptor_activity).permit(:id, :name)
    end
end
