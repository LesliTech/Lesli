class Template::DocumentsController < ApplicationController
    before_action :set_template_document, only: [:show, :edit, :update, :destroy]

    require 'yomu'
    require 'aws-sdk-s3'

    # GET /template/documents
    def index
        respond_to do |format|
            format.html {}
            format.json do
                template_documents = current_user.account.template.documents

                respond_with_successful(template_documents)
            end
        end 
    end

    def show
        respond_to do |format|
            format.html do
                file_obj = s3_client().get_object(
                    bucket: Rails.application.credentials.s3[:bucket],
                    key: @template_document.attachment
                )
        
                send_data file_obj["body"].read(), filename: @template_document.name, type: file_obj["content_type"]

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
        document_text = Yomu.new(params[:file][:attachment]).text
        
        unless document_text.valid_encoding?
            document_text = document_text.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
            variables = document_text.gsub(/\s+/, " ").scan(/\$\$\w+/)
        else
            variables = document_text.gsub(/\s+/, " ").scan(/\$\$\w+/)
        end

        file_name = params[:file][:attachment].original_filename.gsub(/\s+/, " ")
        current_user.account.template.documents.create(name: file_name)

        #upload file to s3
        path = "storage/core/template/documents/#{file_name}"
        s3_object = Template::Document.s3_bucket().object(path)

        s3_object.put(
            body: params[:file][:attachment].to_io, 
            acl: "private"
        ) 

        template_document.update(
            attachment: s3_object.key
        ) 
        
        unless (template_document.blank?)
            Template::Document.scan_variables(current_user, template_document, variables)
            
            respond_with_successful
        end
    end

    def update
        if @template_document.update(template_document_params)
            redirect_to @template_document, notice: 'Document was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        return respond_with_not_found unless @template_document

        if @template_document.destroy

            #delete file in s3
            Template::Document.s3_client().delete_object(
                bucket: Rails.application.credentials.s3[:bucket],
                key: @template_document.attachment
            )

            respond_with_successful(@template_document)
        else
            respond_with_error(@company.errors.full_messages.to_sentence)
        end
    end

    private

    def set_template_document
        @template_document = Template::Document.find(params[:id])
    end

    def template_document_params
        params.require(:template_document).permit(:name, :attachment, :template_type)
    end
end
