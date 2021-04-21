class Templates::CreateCloudObjectFileWithTemplateJob < ApplicationJob
    queue_as :default

    XML_TAG = /\<[^\>]+\>/

    def perform(current_user, cloud_object, document, file_type)
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

        # fetch data of cloud_object query
        query[:fields] = query[:fields].join(",")
        data = cloud_object.template_data(query)

        #looking for method calls
        document_mappings.find_all {|mapping| mapping.variable_type == Template::Variable.variable_types[:method]}.each do |document_map|
            if ((defined? ("#{document_map["table_name"]}.#{document_map["table_alias"]}"||"").constantize) == "method" ) # validate if method is defined

                if (document_map["field_name"] == "today")
                    value = document_map["table_name"].constantize.send(document_map["table_alias"], Time.now)

                    unless value.blank?
                        data = data.merge(document_map["name"].downcase => value)

                        variables.push(document_map["name"])
                    end
                end
            end
        end

        return if data.blank?

        #download file from s3
        s3 = LC::Config::Providers::Aws::S3.new()
        s3_file = s3.get_object(document.attachment)

        #validate if directory exists
        directory_name = "#{Rails.root}/tmp/templates/"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        #write document with variable values
        tmp_path = "#{Rails.root}/tmp/templates/template-#{document.name}"

        doc_template = File.open(tmp_path, "w") do |file|
            file.write s3_file["body"].read()
        end

        doc_template = DocxReplace::Doc.new(tmp_path, "#{Rails.root}/tmp")

        variables.each do |variable| #replace data
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

            cloud_object_file.update({})

            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_create_file",
                description: cloud_object_file.name
            )

            Files::AwsUploadJob.perform_now(cloud_object_file)
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
            if not replacement.blank?
                tag_pattern << '\k<tag' + i.to_s + '>'
                tag_pattern << replacement if i.zero?
            else
                tag_pattern = ""
            end
        end
        tag_pattern.force_encoding('ASCII-8BIT')
        word_xml.gsub!(regexp, tag_pattern)
    end
end
