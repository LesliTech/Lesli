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
    before_action :set_audience, only: [:show, :update, :destroy, :generate_file]

    # GET /audiences
    def index
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Template::Audience.index(current_user, @query))
            }
        end
    end

    def list
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Template::Audience.list(current_user, @query))
            }
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Template::Audience.show(current_user, @audience.id))
            }
        end
    end

    def new
    end

    def edit
    end

    def create
        audience = current_user.account.template.audiences.new(audience_params)

        if audience.save
            respond_with_successful(audience)
        else
            respond_with_error(audience.errors.full_messages)
        end
    end

    def update
        return respond_with_not_found unless @audience

        old_attributes = @audience.attributes

        if @audience.update(audience_params)
            new_attributes = @audience.attributes

            respond_with_successful(@audience)
        else
            respond_with_error(@audience.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @audience

        if @audience.destroy
            respond_with_successful
        else
            respond_with_error(@audience.errors.full_messages.to_sentence)
        end
    end

    def options
        options = Template::AudienceReference.options(current_user, @query)

        respond_with_successful(options)
    end

    def generate_file
        return respond_with_not_found unless @audience

        references_id = import_audience_generete_file_params[:ids]
        template_document_id = import_audience_generete_file_params[:template_document_id]

        Templates::CreateFileForAudienceJob.perform_later(
            current_user,
            @audience,
            template_document_id,
            references_id
        )
    end

    private

    def set_audience
        @audience = current_user.account.template.audiences.find_by(id: params[:id])
    end

    def audience_params
        params.require(:audience).permit(:name, :description, :model_type)
    end

    def import_audience_generete_file_params
        params.permit(:template_document_id, :ids => [])
    end
end
