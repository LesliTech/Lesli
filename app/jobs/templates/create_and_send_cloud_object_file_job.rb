class Templates::CreateAndSendCloudObjectFileJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        custom_href = nil
        if action.input_data["system_url"]
            custom_href = action.input_data["system_url"]
            custom_href = cloud_object.generate_link_url(custom_href)
        end

        file = Templates::CreateCloudObjectFileWithTemplateJob.perform_now(current_user, cloud_object,
            Template::Document.find_by(id: action.input_data["template_id"]),
            action.input_data["file_type"]
        )

        WorkflowActions::SendCoreEmailJob.perform_now(
            current_user,
            cloud_object,
            action,
            attachment_files: [file],
            custom_href: custom_href
        )
    end
end
