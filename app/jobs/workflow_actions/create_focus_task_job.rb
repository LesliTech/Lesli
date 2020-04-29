class WorkflowActions::CreateFocusTaskJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        task_employee = nil
        case action.concerning_users["type"]
        when "main"
            task_employee = cloud_object.get_main_employee
        when "custom"
            task_employee = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
        when "current_user"
            task_employee = current_user
        end

        begin
            replacement_values = {"%global_identifier%" => cloud_object.global_identifier}
            action.parse_input_data(replacement_values)
            input_data = action.input_data

            task_params = {
                user: task_employee,
                model_type: cloud_object.class.name,
                model_id: cloud_object.id,
                detail_attributes: {
                    title: input_data["title"],
                    description: input_data["description"],
                    deadline: LC::Date.now + (input_data["days_until_deadline"] || 0).to_i.days,
                    importance: input_data["importance"],
                    task_type: input_data["task_type"],
                }
            }

            ::Courier::Focus::Task.tasks_new(current_user, task_params, action.configuration["send_email"])
        rescue StandardError => e
            cloud_object.activities.create(
                user: current_user,
                category: "action_workflow_action_failed",
                description: e.message
            )
        end
    end
end
