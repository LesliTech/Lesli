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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class FeedbacksController < ApplicationLesliController
    skip_before_action :authorize_privileges, only: [:create]
    skip_before_action :authorize_request, only: [:create]
    before_action :set_feedback, only: [:show, :update, :destroy]

    # GET /feedbacks/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(FeedbackServices.new(current_user, @query).list)
            end
        end
    end

    # GET /feedbacks
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(FeedbackServices.new(current_user, @query).index)
            end
        end
    end

    # GET /feedbacks/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@feedback.show)
            end
        end
    end

    # GET /feedbacks/new
    def new
    end

    # GET /feedbacks/:id/edit
    def edit
    end

    # POST /feedbacks
    def create
        feedback = FeedbackServices.new(current_user, @query).create(feedback_params)
        if feedback.successful?
            respond_with_successful(feedback.result)
        else
            respond_with_error(feedback.errors)
        end
    end

    # PATCH/PUT /feedbacks/:id
    def update
        @feedback.update(feedback_params)

        if @feedback.successful?
            respond_with_successful(@feedback.result)
        else
            respond_with_error(@feedback.errors)
        end
    end

    # DELETE /feedbacks/1
    def destroy
        return respond_with_not_found unless @feedback

        if @feedback.destroy
            respond_with_successful
        else
            respond_with_error(@feedback.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
        @feedback = FeedbackServices.new(current_user, @query).find(params[:id])
        return respond_with_not_found unless @feedback.found?
    end

    # Only allow a list of trusted parameters through.
    def feedback_params
        params.require(:feedback).permit(
            :id, 
            :email, 
            :telephone, 
            :company, 
            :name, 
            :message, 
            :category, 
            :status, 
            :source, 
            :reference
        )
    end
end
