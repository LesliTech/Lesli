class WorkflowActions::CreateCloudObjectFileWithTemplateJob < ApplicationJob
    queue_as :default

    XML_TAG = /\<[^\>]+\>/

    def perform(current_user, cloud_object, document, file_type)
        document_mappings = document.mappings.joins(:variable).select("name, table_alias, table_name, field_name")
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

        #fetch data of cloud_object        
        data = cloud_object.template_data(query)

        #file path to upload in s3
        file_path = cloud_object.class.name.titleize.gsub(/\s+/, "_").downcase

        file_obj = Template::Document.s3_client().get_object(
            bucket: Rails.application.credentials.s3[:bucket],
            key: document[:attachment]
        )

        #validate if directory exists
        directory_name = "#{Rails.root}/tmp/templates/"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        #write document with variable values
        tmp_path = "#{Rails.root}/tmp/templates/template-#{document.name}"

        doc_template = File.open(tmp_path, "w") do |file|
            file.write file_obj["body"].read()
        end

        doc_template = DocxReplace::Doc.new(tmp_path, "#{Rails.root}/tmp")

        variables.each do |variable|
            xml_replace!(doc_template.instance_variable_get(:@document_content), "$$#{variable}", data[variable.downcase].nil? ? "" : data[variable.downcase])
        end
        
        tmp_file = Tempfile.new(["#{document.name}".split(".docx")[0], '.docx'], "#{Rails.root}/tmp/templates/")
        doc_template.commit(tmp_file.path)

        cloud_object_file = cloud_object.files.new(
            name: document.name,
            file_type: file_type,
            user_creator: current_user,
            attachment: File.open(tmp_file.path, "rb") 
        )

        if (cloud_object_file.save)
            
            cloud_object_file.update(
                attachment: "#{cloud_object_file.id}-#{cloud_object_file.attachment_identifier}"
            )

            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_create_file",
                description: cloud_object_file.name
            )
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

# WorkflowActions::CreateCloudObjectFileWithTemplateJob.perform_now(User.find(2), CloudHouse::Project::Detail.find_by(code: 2019073195).project, Template::Document.first, "generated_document")
# 13863
# 2020080427