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
    before_action :set_descriptor_activity, only: [:show, :update, :destroy]

    # GET /descriptor/activities
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Descriptor::Activity.index(current_user, @query))
            end
        end
    end

    # GET /descriptor/activities/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @descriptor_activity
                return respond_with_successful(@descriptor_activity.show(current_user, @query))
            end
        end
    end

    # GET /descriptor/activities/new
    def new
    end

    # GET /descriptor/activities/1/edit
    def edit
    end

    # POST /descriptor/activities
    def create
        descriptor_activity = Descriptor::Activity.new(descriptor_activity_params)
        if descriptor_activity.save
            respond_with_successful(descriptor_activity)
        else
            respond_with_error(descriptor_activity.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /descriptor/activities/1
    def update
        return respond_with_not_found unless @descriptor_activity

        if @descriptor_activity.update(descriptor_activity_params)
            respond_with_successful(@descriptor_activity.show(current_user, @query))
        else
            respond_with_error(@descriptor_activity.errors.full_messages.to_sentence)
        end
    end

    # DELETE /descriptor/activities/1
    def destroy
        return respond_with_not_found unless @descriptor_activity

        if @descriptor_activity.destroy
            respond_with_successful
        else
            respond_with_error(@descriptor_activity.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_descriptor_activity
        @descriptor_activity = current_user.account.descriptor_activities.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def descriptor_activity_params
        params.require(:descriptor_activity).permit(:id, :name)
    end
end
