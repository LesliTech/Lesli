class Template::Document < ApplicationLesliRecord
    belongs_to :template, foreign_key: "templates_id"
    has_many :mappings, foreign_key: "template_documents_id", dependent: :destroy

    validates :name, presence: :true

    def self.index(current_user, query)
        filters = query[:filters]
        template_documents = current_user.account.template.documents.select(
            :id,
            :name,
            :model_type,
            :attachment,
            LC::Date2.new.date_time.db_timestamps
        )

        unless filters[:attachment].blank?
            template_documents = template_documents
            .where.not(attachment: nil) if filters[:attachment] == "true"
        end

        unless filters[:model_type].blank?
            template_documents = template_documents
            .where(model_type: filters[:model_type])
        end

        template_documents
    end

    def self.options

        model_types = []
        model_types.concat(CloudHouse::Template.options) if defined? CloudHouse

        options = {
            model_types: model_types
        }
    end


=begin
    @return         [String]
    @description    returns the path to upload the file in s3
=end
    def file_path
        "storage/core/template/documents/#{id}.docx"
    end

    #upload file to s3
    def self.upload_file(template_document, attachment)
        s3 = LC::Config::Providers::Aws::S3.new()
        s3_file = s3.create_object(template_document.file_path())

        s3_file.put(
            body: attachment.to_io,
            acl: "private"
        )

        template_document.update(
            attachment: s3_file.key
        )
    end

=begin
    @return         [Array]
    @param file     [String]
    @param document [Template::Document]
    @description returns an array with variables extracted which matches the pattern ${}
    @example
        assuming that the file contains the following text
            This is an example of the method ${variable1} and
            I am trying to explain how it works ${variable2}

        puts Template::Document.scan_variables(file)
        will print something like -> [variable1, variable2]
=end
    def self.extract_text(file)
        document_text = DocRipper::rip(file.path)&.strip

        return [] if document_text.blank?

        unless document_text.valid_encoding?
            document_text = document_text.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
        end

        document_variables = document_text
        .gsub(/\s+/, " ") # remove withe spaces
        .scan(/\${1}\{{1}\w+\}/) # find variables with patter ${...}

        return document_variables
    end

=begin
    @param current_user      [User]
    @param template_document [Template::Document]
    @param variables         [Array]
    @description creates a cache of Template::Variable objects that
    will help to replace the variables in the file.
=end
    def self.scan_variables(current_user, template_document, variables)
        variables.each do |variable_name|
            variable_name = variable_name.gsub(/[\$|\{|\}]/, "")&.strip # extract only variable
            current_user.account.template.variables.each do |variable|
                if (variable.name == variable_name)
                    template_document.mappings.find_or_create_by(template_variables_id: variable.id)
                    next
                end
            end
        end
    end
end
