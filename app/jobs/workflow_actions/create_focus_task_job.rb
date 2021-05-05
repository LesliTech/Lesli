class WorkflowActions::CreateFocusTaskJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        task_employee = nil
        case action.concerning_users["type"]
        when "creator"
            task_employee = cloud_object.user_creator
        when "main"
            task_employee = cloud_object.user_main
        when "custom"
            task_employee = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
        when "current_user"
            task_employee = current_user
        when "branch_office"
            task_employee = cloud_object.user_branch_office
        when "reviewer"
            task_employee = cloud_object.user_reviewer
        end

        # Sanity check. If the association doesn't exist, or it is not a user, we default back to current_user
        task_employee = current_user unless task_employee

        begin
            replacement_values = {
                "%global_identifier%" => cloud_object.global_identifier,
                "%user_reviewer%" => (cloud_object.user_reviewer ? cloud_object.user_reviewer.full_name : ""),
                "%user_creator%" => (cloud_object.user_creator ? cloud_object.user_creator.full_name : ""),
                "%current_user%" => (current_user.full_name || ""),
                "%status%" => cloud_object.status.name
            }
            action.parse_input_data(replacement_values)
            input_data = action.input_data

            # Defined in CloudObject::Base.focus_task_target
            task_target = cloud_object.focus_task_target
            model_id = task_target[:id]
            model_type = task_target[:class]

            # If cloud_object is a task, the new task will be associated to the cloud_object of the original task, and not to the task itself
            if cloud_object.class.name == "CloudFocus::Task"
                task_employee = cloud_object.model.user_main if action.concerning_users["type"] == "main"
                model_id = cloud_object.model_id
                model_type = cloud_object.model_type
            end

            task_params = {
                user_main: task_employee,
                model_type: model_type,
                model_id: model_id,
                cloud_focus_catalog_task_types_id: input_data["task_type"],
                detail_attributes: {
                    title: input_data["title"],
                    description: input_data["description"],
                    deadline: LC::Date.now + (input_data["days_until_deadline"] || 0).to_i.days,
                    importance: input_data["importance"]
                }
            }

            ::Courier::Focus::Task.tasks_new(current_user, task_params, action.configuration["send_email"])
        rescue StandardError => e
            if action.configuration["log_errors"]
                cloud_object.activities.create(
                    user_creator: current_user,
                    category: "action_workflow_action_failed",
                    description: e.message
                )
            end
        end
    end
end
