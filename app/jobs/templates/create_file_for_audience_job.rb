require 'combine_pdf'
require 'libreconv'

class Templates::CreateFileForAudienceJob < ApplicationJob
    queue_as :default

    XML_TAG = /\<[^\>]+\>/

    def perform(current_user, audience, template_document_id, references_id)

        template = current_user.account.template.documents.find_by(id: template_document_id) # template document

        word_template_file = LC::Config::Providers::Aws::S3.new()
        word_template_file = word_template_file.get_object(template.attachment) # download word template file from s3

        doc_template_path = "#{Rails.root}/tmp/templates-#{template.name}"

        File.open(doc_template_path, "w") do |file|
            file.write word_template_file["body"].read()
        end

        document_mappings = template.mappings.joins(:variable).select("name, table_alias, table_name, field_name") # template variables
        query = {
            fields: [],
            mapping: {}
        }

        variables = []

        document_mappings.each do |document_map|

            unless document_map["table_alias"].blank?
                table_alias = document_map["table_alias"]
            else
                table_alias = document_map["table_name"].split("_").map { |e| e.chars.first}.join("")
            end

            variables.push(document_map["name"])

            query[:mapping][document_map["name"]] = { field_name: document_map["field_name"], alias: document_map["table_alias"]}
            query[:fields].push("#{table_alias}.#{document_map["field_name"]} as #{document_map["name"]}")
        end

        query[:fields] = query[:fields].join(",")

        #validate if directories exist
        directory_name = "#{Rails.root}/tmp/templates/"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        directory_name = "#{Rails.root}/tmp/pdfs/"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        # end #

        # billing document variables #

        billing_filename = "FILE-TEST.pdf"

        # end #

        final_pdf = CombinePDF.new # final doc

        audience.model_type.constantize.where(id: references_id)
        .order(:id)
        .each do |property_management|
            ############### GENERATE WORD DOCUMENT ###############

            #fetch data of the object
            data = property_management.template_data(query)

            #write document with variable values
            doc_template = DocxReplace::Doc.new(doc_template_path, "#{Rails.root}/tmp")

            variables.each do |variable|
                xml_replace!(doc_template.instance_variable_get(:@document_content), "$$#{variable}", data[variable.downcase].nil? ? "" : data[variable.downcase])
            end

            tmp_file = Tempfile.new(["#{property_management.id}-#{template.name}".split(".docx")[0], '.docx'], "#{Rails.root}/tmp/templates/")
            doc_template.commit(tmp_file.path)

            # convert to pdf
            Libreconv.convert(tmp_file.path, "#{Rails.root}/tmp/pdfs/test-script.pdf")

            final_pdf << CombinePDF.load("#{Rails.root}/tmp/pdfs/test-script.pdf")  #join file

            ############################### END ################################
        end

        upload_document(final_pdf)
    end

    def upload_document(final_pdf)

        file_path = "storage/core/template/audience/merge-word"
        file_path += "-test" if Rails.env.development?
        file_path += ".pdf"

        s3 = LC::Config::Providers::Aws::S3.new()
        s3_file = s3.create_object(file_path)

        s3_file.put(
            body: final_pdf.to_pdf,
            acl: "private"
        )
    end

    def xml_replace!(word_xml, pattern, replacement)

        regexp = //
        tag_pattern = '' # tag_pattern is the resulting replacement with the XML tags intact
        replacement = replacement.to_s.encode(xml: :text)

        # Generate tag_pattern and regexp
        pattern.to_s.each_char.each_with_index do |char, i|
            rc = Regexp.quote(char)
            rc = rc.force_encoding('ASCII-8BIT')
            regexp = /#{regexp}(?<tag#{i}>(#{XML_TAG})*)#{rc}/
            tag_pattern << '\k<tag' + i.to_s + '>'
            tag_pattern << replacement if i.zero?
        end
        tag_pattern.force_encoding('ASCII-8BIT')
        word_xml.gsub!(regexp, tag_pattern)
    end
end
