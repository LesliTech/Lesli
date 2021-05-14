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
class Template::AudienceDocumentsController < ApplicationLesliController
    before_action :set_audience_file, only: [:show, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Template::AudienceDocument.index(current_user, @query))
            end
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @audience_document
                return respond_with_successful(@audience_document.show(current_user, @query))
            end
        end
    end

    def new
    end

    def edit
    end

    def create
        audience_document = Template::AudienceDocument.new(audience_file_params)
        if audience_document.save
            respond_with_successful(audience_document)
        else
            respond_with_error(audience_document.errors.full_messages.to_sentence)
        end
    end

    def update
        return respond_with_not_found unless @audience_document

        if @audience_document.update(audience_file_params)
            respond_with_successful(@audience_document.show(current_user, @query))
        else
            respond_with_error(@audience_document.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @audience_document

        if @audience_document.destroy
            respond_with_successful
        else
            respond_with_error(@audience_document.errors.full_messages.to_sentence)
        end
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

    def options
        options = Template::AudienceDocument.options(current_user, @query)

        respond_with_successful(options)
    end

    private

    def set_audience_file
        @audience_document = current_user.account.template.audience_files.find_by(id: params[:id])
    end

    def audience_file_params
        params.require(:audience_document).permit(:name, :description, :model_type)
    end

    def import_audience_generete_file_params
        params.permit(:template_document_id, :ids => [])
    end
end