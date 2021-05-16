require 'combine_pdf'
require 'libreconv'

class Templates::CreateFileForAudienceJob < ApplicationJob
    queue_as :default

    XML_TAG = /\<[^\>]+\>/

    def perform(current_user, audience_document, template_document_id, references_id)
        document = current_user.account.template.documents.find_by(id: template_document_id) # template document

        word_template_file = LC::Config::Providers::Aws::S3.new()
        word_template_file = word_template_file.get_object(document.attachment) # download word document file from s3

        doc_template_path = "#{Rails.root}/tmp/templates/#{document.id}-#{document.name}"

        File.open(doc_template_path, "w") do |file|
            file.write word_template_file["body"].read()
        end

        document_mappings = document.mappings.joins(:variable).select("name, table_alias, table_name, field_name, template_variables.variable_type")
        query = {
            fields: [],
            mapping: {}
        }

        variables = []

        document_mappings.find_all {|mapping| mapping.variable_type == Template::Variable.variable_types[:table]}.each do |document_map|

            unless document_map["table_alias"].blank?
                table_alias = document_map["table_alias"]
            else
                table_alias = (document_map["table_name"]||"").split("_").map { |e| e.chars.first}.join("")
            end

            variables.push(document_map["name"])

            query[:mapping][document_map["name"]] = { field_name: document_map["field_name"], alias: document_map["table_alias"]}

            if not (document_map["table_name"].blank?)
                query[:fields].push("#{table_alias}.#{document_map["field_name"]} as #{document_map["name"]}")
            end
        end

        document_data = {}
        #looking for method calls
        document_mappings.find_all {|mapping| mapping.variable_type == Template::Variable.variable_types[:method]}.each do |document_map|
            if ((defined? ("#{document_map["table_name"]}.#{document_map["table_alias"]}"||"").constantize) == "method" ) # validate if method is defined

                if (document_map["field_name"] == "today")
                    value = document_map["table_name"].constantize.send(document_map["table_alias"], Time.now)

                    unless value.blank?
                        document_data = document_data.merge(document_map["name"].downcase => value)

                        variables.push(document_map["name"])
                    end
                end
            end
        end

        #validate if directories exist
        directory_name = "#{Rails.root}/tmp/templates/"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        directory_name = "#{Rails.root}/tmp/pdfs/"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        # end #

        final_pdf = CombinePDF.new # final doc
        pdf_tmp_path = "#{Rails.root}/tmp/pdfs/#{audience_document.id}-#{document.name}.pdf"

        audience_document.model_type.constantize.where(id: references_id)
        .order(:id)
        .each do |object|
            ############### GENERATE WORD DOCUMENT ###############

            #fetch data of the object
            data = document_data.merge(object.template_data(query))

            #write document with variable values
            doc_template = DocxReplace::Doc.new(doc_template_path, "#{Rails.root}/tmp")

            variables.each do |variable|
                xml_replace!(doc_template.instance_variable_get(:@document_content), "$$#{variable}", data[variable.downcase].nil? ? "" : data[variable.downcase])
            end

            tmp_file = Tempfile.new(["#{object.id}-#{document.name}".split(".docx")[0], '.docx'], "#{Rails.root}/tmp/templates/")
            doc_template.commit(tmp_file.path)

            # convert to pdf
            Libreconv.convert(tmp_file.path, pdf_tmp_path)

            final_pdf << CombinePDF.load(pdf_tmp_path)  #join file

            ############################### END ################################
        end

        final_pdf.save pdf_tmp_path

        upload_document(current_user, audience_document, document, pdf_tmp_path)
    end

    def upload_document(current_user, audience_document, document, pdf_tmp_path)

        if (audience_document&.file.present?) # update file
            file = current_user.account.files.find_by(id: audience_document.file.id)

            file.destroy
        end


        file = current_user.account.files.new(
            file_type: "template_audience",
            user_creator: current_user,
            attachment_s3: File.open(pdf_tmp_path, "rb"),
            name: "#{(audience_document.name||'').gsub(/\s+/, "-")}.pdf"
        )

        if file.save
            file.update({})

            audience_document.update(file: file) # update audience file

            # send email
            url = "/administration/account/files/#{file.id}?download=true"

            TemplateMailer.with(url: url, audience_document: audience_document).audience_document_ready.deliver_now
        end
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
