class WorkflowActions::SendCoreEmailJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action, attachment_files: nil, custom_href: nil)
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
                href = "/crm#{cloud_object.urn}"
            else
                href = "/#{class_data[0].gsub("Cloud", "").underscore()}#{cloud_object.urn}"
            end

            href = custom_href if custom_href 

            emails = []
            case action.concerning_users["type"]
            when "creator"
                user = cloud_object.user_creator
                user = current_user unless user
                user = user.attributes

                emails.push(user["email"])
                send_email(user, action, input_data, href, attachment_files)
            when "main"
                user = cloud_object.user_main.attributes
                return unless user

                emails.push(user["email"])
                send_email(user, action, input_data, href, attachment_files)
            when "current_user"
                user = current_user.attributes
                emails.push(user["email"])
                send_email(user, action, input_data, href, attachment_files)
            when "custom"
                action.concerning_users["list"].each do |user|
                    emails.push(user["email"])
                    send_email(user, action, input_data, href, attachment_files)
                end
            when "branch_office"
                user = cloud_object.user_branch_office
                return unless user

                user = user.attributes

                emails.push(user["email"])
                send_email(user, action, input_data, href, attachment_files)
            when "reviewer"
                user = cloud_object.user_reviewer
                return unless user
                
                user = user.attributes

                emails.push(user["email"])
                send_email(user, action, input_data, href, attachment_files)
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

    def send_email(user, action, input_data, href, attachment_files)
        data = {
            name: (user["name"] || user["email"]),
            body: input_data["body"],
            href: href
        }
        mailer = action.configuration["mailer"].constantize
        
        options = {}
        if attachment_files && attachment_files.length > 0
            options[:attachment_files] = attachment_files
        end


        Workflow::ActionMailer.with({user: user, subject: input_data["subject"], data: data, options: options}).generic.deliver_now
    end
end
