class WorkflowActions::SendCoreEmailJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        begin
            replacement_values = {
                "%global_identifier%" => cloud_object.global_identifier,
                "%current_user%" => (current_user.full_name || ""),
                "%user_creator%" => (cloud_object.user_creator ? cloud_object.user_creator.full_name : ""),
                "%user_reviewer%" => (cloud_object.user_reviewer ? cloud_object.user_reviewer.full_name : ""),
                "%status%" => cloud_object.status.name
            }
            action.parse_input_data(replacement_values)
            input_data = action.input_data

            class_data = cloud_object.class.name.split("::")
            
            # @todo Improve this href definition
            if defined? DeutscheLeibrenten
                href = "/crm/#{class_data[1].downcase().pluralize()}/#{cloud_object.url_identifier}"
            else
                href = "/#{class_data[0].downcase().gsub("Cloud", "")}/#{class_data[1].downcase().pluralize()}/#{cloud_object.id}"
            end

            emails = []
            case action.concerning_users["type"]
            when "creator"
                user = cloud_object.user_creator
                user = current_user unless user
                user = user.attributes

                emails.push(user["email"])
                send_email(user, action, input_data, href)
            when "main"
                user = cloud_object.user_main.attributes
                return unless user

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
            when "branch_office"
                user = cloud_object.user_branch_office
                user = current_user unless user
                user = user.attributes

                emails.push(user["email"])
                send_email(user, action, input_data, href)
            when "reviewer"
                user = cloud_object.user_reviewer
                user = current_user unless user
                user = user.attributes

                emails.push(user["email"])
                send_email(user, action, input_data, href)
            end

            cloud_object.activities.create!(
                user_creator: current_user,
                category: "action_email_sent",
                description: emails.join(", ")
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
