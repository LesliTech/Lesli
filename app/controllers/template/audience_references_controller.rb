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
class Template::AudienceReferencesController < ApplicationLesliController
    before_action :set_template_audience_reference, only: [:show, :update, :destroy]

    # GET /template/audience_references
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Template::AudienceReference.index(current_user, @query))
            end
        end
    end

    # GET /template/audience_references/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @template_audience_reference
                return respond_with_successful(@template_audience_reference.show(current_user, @query))
            end
        end
    end

    # GET /template/audience_references/new
    def new
    end

    # GET /template/audience_references/1/edit
    def edit
    end

    # POST /template/audience_references
    def create
        template_audience_reference = Template::AudienceReference.new(template_audience_reference_params)
        if template_audience_reference.save
            respond_with_successful(template_audience_reference)
        else
            respond_with_error(template_audience_reference.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /template/audience_references/1
    def update
        return respond_with_not_found unless @template_audience_reference

        if @template_audience_reference.update(template_audience_reference_params)
            respond_with_successful(@template_audience_reference.show(current_user, @query))
        else
            respond_with_error(@template_audience_reference.errors.full_messages.to_sentence)
        end
    end

    # DELETE /template/audience_references/1
    def destroy
        return respond_with_not_found unless @template_audience_reference

        if @template_audience_reference.destroy
            respond_with_successful
        else
            respond_with_error(@template_audience_reference.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_template_audience_reference
        @template_audience_reference = current_user.account.template_audience_references.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template_audience_reference_params
        params.require(:template_audience_reference).permit(:id, :name)
    end
end
