class Template::Document < ApplicationLesliRecord
    belongs_to :template, foreign_key: "templates_id"
    has_many :mappings, foreign_key: "template_documents_id", dependent: :destroy 

    require 'aws-sdk-s3'
    require 'yomu'

    def self.index(current_user, query)
        filters = query[:filters]
        template_documents = current_user.account.template.documents

        unless filters.blank?
            template_documents = template_documents
            .where.not(attachment: nil) if filters[:attachment] == "true"
        end
    end
    
    def self.options

        model_types = []
        model_types.concat(CloudHouse::Template.options) if defined? CloudHouse

        options = {
            model_types: model_types
        }
    end

    def self.upload_file(template_document, file_path, attachment)
        #upload file to s3
        s3_object = Template::Document.s3_bucket().object(file_path)

        s3_object.put(
            body: attachment.to_io, 
            acl: "private"
        ) 

        template_document.update(
            attachment: s3_object.key
        ) 
    end

    def self.s3_client
        return( 
            Aws::S3::Client.new(
                region: Rails.application.credentials.s3[:region],
                access_key_id: Rails.application.credentials.s3[:access_key_id], 
                secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
            )
        )
    end

    def self.s3_bucket
        return ( 
            Aws::S3::Resource.new(
                region: Rails.application.credentials.s3[:region],
                access_key_id: Rails.application.credentials.s3[:access_key_id], 
                secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
            ).bucket(Rails.application.credentials.s3[:bucket])
        )
    end

    def self.extract_text(file)
        document_text = Yomu.new(file).text
        
        unless document_text.valid_encoding?
            document_text = document_text.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
            document_variables = document_text.gsub(/\s+/, " ").scan(/\$\$\w+/)
        else
            document_variables = document_text.gsub(/\s+/, " ").scan(/\$\$\w+/)
        end

        return document_variables
    end

    def self.scan_variables(current_user, template_document, variables)
        variables.each do |variable_name|
            variable_name = variable_name.gsub("$$", "")
            current_user.account.template.variables.each do |variable|
                if (variable.name == variable_name)
                    template_document.mappings.find_or_create_by(template_variables_id: variable.id)
                    next
                end
            end
        end
    end
end
