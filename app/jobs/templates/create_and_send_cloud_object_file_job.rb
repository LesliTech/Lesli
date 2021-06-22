class Templates::CreateAndSendCloudObjectFileJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        file = Templates::CreateCloudObjectFileWithTemplateJob.perform_now(current_user, cloud_object,
            Template::Document.find_by(id: action.input_data["template_id"]),
            action.input_data["file_type"]
        )

        WorkflowActions::SendCoreEmailJob.perform_now(
            current_user,
            cloud_object,
            action,
            attachment_files: [file]
        )
    end
end
