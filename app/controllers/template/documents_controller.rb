=begin

Copyright (c) 2020, all rights reserved.

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

class Template::DocumentsController < ApplicationLesliController
    before_action :set_template_document, only: [:show, :edit, :update, :destroy]

    def privileges
        {
            index: [],
            show: ["generate"]
        }
    end

=begin
@return [Json] Json that contains a list of all documents created
@description Retrieves and returns all documents that belongs to the current_users's account
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    this.http.get(`127.0.0.1/administration/template/documents.json`);
=end
    def index
        respond_to do |format|
            format.html {}
            format.json do
                template_documents = Template::Document.index(current_user, @query)

                respond_with_successful(template_documents)
            end
        end
    end
=begin
@return [HTML|Json] HTML view showing the requested template document or a Json that contains the
    information of the template document. If there is an error, an explanation message is sent
@description Retrieves and returns the requested template document. The id of the
    template document is within the *params* attribute of the controller. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered. This is the only method that uses the project
    code instead of the ID for searching.
@example
    # Executing this controller's action from javascript's frontend
    let template_document_id = 1;
    this.http.get(`127.0.0.1/administration/template/documents${template_document_id}.json`);
=end
    def show
        respond_to do |format|
            format.html do
                begin
                    s3 = LC::Config::Providers::Aws::S3.new()
                    s3_file = s3.get_object(@template_document.attachment)
                    send_data(s3_file["body"].read, filename: @template_document.name, disposition: "inline", stream: "true")
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

=begin
@controller_action_param :file_template [File] The uploaded file
@controller_action_param :model_type [String] The name of the model wich belongs to
@return [Json] Json that contains wheter the creation of the file was successful or not.
    If it is not successful, it returs an error message
@description Creates a new template document
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let data = {
        template_document: {
            file_template: FILE_CONTENT
            model_type: "CloudHouse::Company"
        }
    };
    this.http.post(`127.0.0.1/administration/template/documents.json`, data);
=end
    def create
        attachment = params[:template_document][:attachment]

        document_variables = Template::Document.extract_text(attachment)

        if (document_variables.blank?)
            return respond_with_error(I18n.t("core.template/documents.error_document_without_variables"))
        end

        template_document = current_user.account.template.documents.new(template_document_params)

        if (template_document.save)
            Template::Document.scan_variables(current_user, template_document, document_variables)

            Template::Document.upload_file(template_document, attachment)

            respond_with_successful(template_document)
        else
            respond_with_error(template_document.errors.full_messages.to_sentence)
        end
    end

=begin
@controller_action_param :file_template [File] The uploaded file_template
@controller_action_param :model_type [String] The name of the model wich belongs to
@return [Json] Json that contains wheter the creation of the file was successful or not.
    If it is not successful, it returs an error message
@description Update a template document
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let data = {
        template_document: {
            file_template: FILE_CONTENT

        }
    };
    let template_document_id = 1

    this.http.put(`127.0.0.1/administration/template/documents/${template_document_id}.json`, data);
=end
    def update
        attachment = params[:template_document][:attachment]
        return respond_with_not_found unless @template_document

        document_variables = Template::Document.extract_text(attachment)

        return respond_with_error(I18n.t("core.template/documents.error_document_without_variables")) if document_variables.blank?

        if @template_document.update(template_document_params)
            Template::Document.scan_variables(current_user, @template_document, document_variables)

            Template::Document.upload_file(@template_document, attachment)
        else
            respond_with_error(@template_document.errors.full_messages.to_sentence)
        end

        respond_with_successful()
    end

=begin
    @return [Json] A response that contains wheter the template document was deleted or not.
        If it is not successful, it returns an error message
    @description Deletes a template document from the database based on the id of the *cloud_object* and its own id.
    @example
        # Executing this controller's action from javascript's frontend
        let template_document_id = 1

        this.http.delete(`127.0.0.1/administration/template/documents/${template_document_id}.json`, data);
=end
    def destroy

        return respond_with_not_found unless @template_document

        if @template_document.destroy
            s3 = LC::Config::Providers::Aws::S3.new()
            s3.delete_object(@template_document.attachment)

            respond_with_successful(@template_document)
        else
            respond_with_error(@template_document.errors.full_messages.to_sentence)
        end
    end

=begin
@controller_action_param :model_type [String] The class of the cloud object
@controller_action_param :model_id [String] The id of the cloud object
@return [void] It will generate a file to the cloud object through a job execution
@description Creates a new template document
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let data = {
        cloud_object: {
            model_id: 2
            model_type: "CloudHouse::Company"
        }
    };
    let template_document_id = 1
    this.http.post(`127.0.0.1/administration/template/documents/${template_document_id}.json`, data);
=end
    def generate
        set_template_document
        set_cloud_object

        Templates::CreateCloudObjectFileWithTemplateJob.perform_now(
            current_user,
            @cloud_object,
            @template_document,
            cloud_object_file_params["file_type"]
        )

        respond_with_successful
    end

=begin
@return [Json] Json that contains all the information needed to create a template document
@description Retrieves and retuns all the information needed to create a template document,
    including the list of companies and contacts.
@example
    # Executing this controller's action from javascript's frontend
    this.http.get(`127.0.0.1/administration/template/documents/options.json`);
=end
    def options
        respond_with_successful(Template::Document.options)
    end

    private

=begin
@return [void]
@description Sets the cloud_object based on the current_users's account
@example
    # Executing this method from a controller action:
    set_cloud_object
    puts @cloud_object
    # This will either display nil or an instance of CloudObject
=end
    def set_cloud_object
        @cloud_object = cloud_object_file_params[:model_type].constantize.find_by(id: cloud_object_file_params[:model_id])
    end

=begin
@return [void]
@description Sets the requested template document based on the current_users's account
@example
    # Executing this method from a controller action:
    set_template_document
    puts @template_document
    # This will either display nil or an instance of Template::Document
=end
    def set_template_document
        @template_document = current_user.account.template.documents.find_by(id: params[:id])
    end

=begin
@return [Parameters] Allowed parameters for the file
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
@example
    # supose params contains {
    #    "cloud_object": {
    #        "model_id": 5,
    #        "model_type": "CloudHouse::Project",
    #        "title": "Test"
    #    }
    #}
    file_params = cloud_object_file_params
    puts file_params
    # will remove test field and only print {
    #    "cloud_object": {
    #        "model_id": 5,
    #        "model_type": "CloudHouse::Project"
    #    }
    #}
=end
    def cloud_object_file_params
        params.require(:cloud_object).permit(:model_id, :model_type, :file_type)
    end

=begin
@return [Parameters] Allowed parameters for the file_template
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
@example
    # supose params contains {
    #    "cloud_object": {
    #        "name": 5,
    #        "model_type": "CloudHouse::Project",
    #        "file_template": File
    #        "description": 2Test"
    #    }
    #}
    file_params = cloud_object_file_params
    puts file_params
    # will remove description field and only print {
    #    "cloud_object": {
    #        "name": 5,
    #        "model_type": "CloudHouse::Project"
    #        "file_template": File
    #    }
    #}
=end
    def template_document_params
        params.require(:template_document).permit(:name, :model_type)
    end
end
