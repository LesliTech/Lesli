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
class Template::AudiencesController < ApplicationLesliController
    before_action :set_template_audience, only: [:show, :update, :destroy]

    # GET /template/audiences
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Template::Audience.index(current_user, @query))
            end
        end
    end

    # GET /template/audiences/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @template_audience
                return respond_with_successful(@template_audience.show(current_user, @query))
            end
        end
    end

    # GET /template/audiences/new
    def new
    end

    # GET /template/audiences/1/edit
    def edit
    end

    # POST /template/audiences
    def create
        template_audience = Template::Audience.new(template_audience_params)
        if template_audience.save
            respond_with_successful(template_audience)
        else
            respond_with_error(template_audience.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /template/audiences/1
    def update
        return respond_with_not_found unless @template_audience

        if @template_audience.update(template_audience_params)
            respond_with_successful(@template_audience.show(current_user, @query))
        else
            respond_with_error(@template_audience.errors.full_messages.to_sentence)
        end
    end

    # DELETE /template/audiences/1
    def destroy
        return respond_with_not_found unless @template_audience

        if @template_audience.destroy
            respond_with_successful
        else
            respond_with_error(@template_audience.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_template_audience
        @template_audience = current_user.account.template_audiences.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template_audience_params
        params.require(:template_audience).permit(:id, :name)
    end
end
