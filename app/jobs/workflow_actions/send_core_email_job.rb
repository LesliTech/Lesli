class WorkflowActions::SendCoreEmailJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        begin
            replacement_values = {
                "%global_identifier%" => cloud_object.global_identifier,
                "%current_user%" => (current_user.name || "")
            }
            action.parse_input_data(replacement_values)
            input_data = action.input_data

            class_data = cloud_object.class.name.split("::")
            
            # @todo Improve this href definition
            if defined? CloudHaus
                href = "/crm/#{class_data[1].downcase().pluralize()}/#{cloud_object.id}"
            else
                href = "/#{class_data[0].downcase().gsub("Cloud", "")}/#{class_data[1].downcase().pluralize()}/#{cloud_object.id}"
            end

            emails = []
            case action.concerning_users["type"]
            when "main"
                user = cloud_object.get_main_employee.attributes
                emails.push(user["email"])
                send_email(user, action, input_data, href)
            when "current_user"
                user = current_user.attributes
                emails.push(user["email"])
                send_email(user, action, input_data, href)
            when "custom"
                action.concerning_users["list"].each do |user|
                    emails.push(user["email"])
                    send_email(user, action, input_data, href)
                end
            end

            cloud_object.activities.create!(
                user: current_user,
                category: "action_email_sent",
                description: emails.join(", ")
            )
            
        rescue StandardError => e
            if action.configuration["log_errors"]
                cloud_object.activities.create(
                    user: current_user,
                    category: "action_workflow_action_failed",
                    description: e.message
                )
            end
        end
    end

    def send_email(user, action, input_data, href)
        data = {
            name: (user["name"] || user["email"]),
            body: input_data["body"],
            href: href
        }
        mailer = action.configuration["mailer"].constantize
        mailer.generic(user["email"], input_data["subject"], data, template: action.template_path).deliver_now
    end
end
