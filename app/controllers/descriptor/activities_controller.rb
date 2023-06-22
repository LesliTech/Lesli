=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class Descriptor::ActivitiesController < ApplicationController
    before_action :set_descriptor_activity, only: [:show, :update, :destroy]

    # GET /descriptor/activities/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Descriptor::ActivityServices.new(current_user, query).list)
            end
        end
    end

    # GET /descriptor/activities
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(Descriptor::ActivityServices.new(current_user, query).index)
            end
        end
    end

    # GET /descriptor/activities/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@descriptor_activity.show)
            end
        end
    end

    # GET /descriptor/activities/new
    def new
    end

    # GET /descriptor/activities/:id/edit
    def edit
    end

    # POST /descriptor/activities
    def create
        descriptor_activity = Descriptor::ActivityServices.new(current_user, query).create(descriptor_activity_params)
        if descriptor_activity.successful?
            respond_with_successful(descriptor_activity.result)
        else
            respond_with_error(descriptor_activity.errors)
        end
    end

    # PATCH/PUT /descriptor/activities/:id
    def update
        @descriptor_activity.update(descriptor_activity_params)

        if @descriptor_activity.successful?
            respond_with_successful(@descriptor_activity.result)
        else
            respond_with_error(@descriptor_activity.errors)
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
        @descriptor_activity = Descriptor::ActivityServices.new(current_user, query).find(params[:id])
        return respond_with_not_found unless @descriptor_activity.found?
    end

    # Only allow a list of trusted parameters through.
    def descriptor_activity_params
        params.require(:descriptor_activity).permit(:id, :name)
    end
end
