class WorkflowActions::CreateCloudObjectFileJob < ApplicationJob
    queue_as :default

    XML_TAG = /\<[^\>]+\>/

    def perform(current_user, cloud_object, document, file_type = "property_owner_correspondence")
        document_mappings = document.mappings.joins(:variable).select("name, table_alias, table_name, field_name")
        fields = []
        variables = []

        document_mappings.each do |document_map|

            unless document_map["table_alias"].blank?
                table_alias = document_map["table_alias"]
            else
                table_alias = document_map["table_name"].split("_").map { |e| e.chars.first}.join("")
            end 
            
            variables.push(document_map["name"])
            fields.push("#{table_alias}.#{document_map["field_name"]} as #{document_map["name"]}")
        end

        fields = fields.join(",")

        #fetch data depending of cloud_object class
        if (cloud_object.class.name == "CloudHouse::Project")
            data = query_projects(cloud_object, fields)
            file_path = "storage/cloud_house/project/#{cloud_object.id}"
        elsif (cloud_object.class.name == "CloudHouse::Company")
            file_path = "storage/cloud_house/company/#{cloud_object.id}"
            data = query_companies(cloud_object, fields)
        elsif (cloud_object.class.name == "CloudDriver::Event")
            file_path = "storage/cloud_driver/event/#{cloud_object.id}"
            data = query_events(cloud_object, fields)
        end

        file_obj = Template::Document.s3_client().get_object(
            bucket: Rails.application.credentials.s3[:bucket],
            key: document[:attachment]
        )

        #validate directory
        directory_name = "templates"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        #write document with variable values
        tmp_path = "#{Rails.root}/tmp/templates/template-#{document.name}.docx"

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

    def query_projects(cloud_object, selected_fields)
        data = cloud_object.class.name.constantize
        .select(selected_fields)
        .joins("
            inner join cloud_house_project_details chpd
                on chpd.cloud_house_projects_id = cloud_house_projects.id      
        ").joins("
            inner join cloud_house_properties chp 
                on cloud_house_projects.cloud_house_properties_id = chp.id          
        ").joins("
            inner join account_locations L 
                on chp.location_city_id = L.id
        ").joins("
            inner join cloud_house_project_customers chpc1 
                on chpc1.cloud_house_projects_id = cloud_house_projects.id
                and chpc1.role = 1
        ").joins("
            inner join cloud_house_contacts chc1 
                on chpc1.cloud_house_contacts_id = chc1.id
        ").joins("
            inner join cloud_house_contact_details chcd1 
                on chcd1.cloud_house_contacts_id = chc1.id
        ").joins("
            left join account_locations chcd1_location 
                on chcd1_location.id = chc1.location_city_id 
        ").joins("
            left join cloud_house_project_customers chpc2
                on chpc2.cloud_house_projects_id = cloud_house_projects.id
                and chpc2.role = 0
        ").joins("
            left join cloud_house_contacts chc2 
                on chpc2.cloud_house_contacts_id = chc2.id
        ").joins("
            left join cloud_house_contact_details chcd2 
                on chcd2.cloud_house_contacts_id = chc2.id
        ").joins("
            left join account_locations chcd2_location 
                on chcd2_location.id = chc2.location_city_id 
        ").joins("
            inner join cloud_house_workflow_statuses chws 
                on cloud_house_projects.cloud_house_workflow_statuses_id = chws.id
        ").joins("
            inner join users u
                on u.id = cloud_house_projects.user_main_id 
        ").joins("
            inner join user_details ud 
                on ud.users_id = u.id 
        ")
        .where("cloud_house_projects.id = ?", "#{cloud_object.id}")
        .first
        .attributes

    end
end

# WorkflowActions::CreateDocumentJob.perform_now(User.find(2), CloudHouse::Project::Detail.find_by(code: 2020080427).project, Template::Document.first)
