class WorkflowActions::CreateBellNotificationJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        notification_user = nil
        case action.concerning_users["type"]
        when "creator"
            notification_user = cloud_object.user_creator
        when "main"
            notification_user = cloud_object.user_main
        when "branch_office"
            notification_user = cloud_object.user_branch_office
        when "custom"
            notification_user = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
        when "current_user"
            notification_user = current_user
        end

        # Sanity check. If the association doesn't exist, or it is not a user, we default back to current_user
        notification_user = current_user unless notification_user

        begin
            replacement_values = {
                "%global_identifier%" => cloud_object.global_identifier,
                "%user_reviewer%" => (cloud_object.user_reviewer ? cloud_object.user_reviewer.full_name : ""),
                "%user_branch_office%" => (cloud_object.user_branch_office ? cloud_object.user_branch_office.full_name : ""),
                "%user_creator%" => (cloud_object.user_creator ? cloud_object.user_creator.full_name : ""),
                "%current_user%" => (current_user.full_name || ""),
                "%status%" => cloud_object.status.name
            }
            action.parse_input_data(replacement_values)
            input_data = action.input_data

            class_data = cloud_object.class.name.split("::")
            
            # @todo Improve this href definition
            if defined? DeutscheLeibrenten
                href = "/crm/#{class_data[1].downcase().pluralize()}/#{cloud_object.id}"
            else
                href = "/#{class_data[0].downcase().gsub("Cloud", "")}/#{class_data[1].downcase().pluralize()}/#{cloud_object.id}"
            end


            Courier::Bell::Notification::Web.new(
                notification_user,
                input_data["subject"],
                body: input_data["body"],
                href: href,
                category: input_data["category"]
            )
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
