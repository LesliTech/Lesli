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

class DescriptorsController < ApplicationLesliController
    before_action :set_descriptor, only: [:show, :update, :destroy]

    # GET /descriptors/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(DescriptorServices.new(current_user, @query).list)
            end
        end
    end

    # GET /descriptors
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(DescriptorServices.new(current_user, @query).index)
            end
        end
    end

    # GET /descriptors/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@descriptor.show)
            end
        end
    end

    # GET /descriptors/new
    def new
    end

    # GET /descriptors/:id/edit
    def edit
    end

    # POST /descriptors
    def create
        descriptor = DescriptorServices.new(current_user, @query).create(descriptor_params)
        if descriptor.successful?
            respond_with_successful(descriptor.result)
        else
            respond_with_error(descriptor.errors)
        end
    end

    # PATCH/PUT /descriptors/:id
    def update
        @descriptor.update(descriptor_params)

        if @descriptor.successful?
            respond_with_successful(@descriptor.result)
        else
            respond_with_error(@descriptor.errors)
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
        @descriptor = DescriptorServices.new(current_user, @query).find(params[:id])
        return respond_with_not_found unless @descriptor.found?
    end

    # Only allow a list of trusted parameters through.
    def descriptor_params
        params.require(:descriptor).permit(:id, :name)
    end
end
