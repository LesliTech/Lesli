class Template::DocumentsController < ApplicationLesliController
    before_action :set_template_document, only: [:show, :edit, :update, :destroy]

    # GET /template/documents
    def index
        respond_to do |format|
            format.html {}
            format.json do
                template_documents = Template::Document.index(current_user, @query)

                respond_with_successful(template_documents)
            end
        end 
    end

    def show
        respond_to do |format|
            format.html do
                begin
                    s3 = LC::Storage.get_object(@template_document.attachment)
                    send_data s3["body"].read(), filename: @template_document.name, type: s3["content_type"]
                rescue Aws::S3::Errors::NoSuchKey => ex
                    redirect_to "/404" 
                end
            end

            format.json do
                set_template_document

                return respond_with_not_found unless @template_document

                respond_with_successful(@template_document)
            end
        end
    end

    def new
    end

    def edit
    end

    def create
        file_name = params[:file][:attachment].original_filename.gsub(/\s+/, " ")
        file_path = "storage/core/template/documents/#{file_name}"

        document_variables = Template::Document.extract_text(params[:file][:attachment])

        template_document = current_user.account.template.documents.create(
            name: file_name,
            model_type: params[:model_type]
        )
        
        if (document_variables.any?)
            Template::Document.scan_variables(current_user, template_document, document_variables)
        end

        Template::Document.upload_file(template_document, file_path, params[:file][:attachment])

        respond_with_successful()
    end

    def update
        return respond_with_not_found unless @template_document

        document_variables = Template::Document.extract_text(params[:file][:attachment])

        if (document_variables.any?)
            Template::Document.scan_variables(current_user, @template_document, document_variables)
        end

        Template::Document.upload_file(@template_document, @template_document.attachment, params[:file][:attachment])

        respond_with_successful()
    end

    def destroy
        return respond_with_not_found unless @template_document

        if @template_document.destroy

            #delete file in s3
            LC::Storage.delete_object(@template_document.attachment)

            respond_with_successful(@template_document)
        else
            respond_with_error(@template_document.errors.full_messages.to_sentence)
        end
    end

    def options
        respond_with_successful(Template::Document.options)
    end

    private
    
    def set_template_document
        @template_document = current_user.account.template.documents.find(params[:id])
    end

    def template_document_params
        params.require(:template_document).permit(:name, :attachment, :model_type)
    end
end
