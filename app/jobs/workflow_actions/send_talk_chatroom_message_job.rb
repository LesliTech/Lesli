class WorkflowActions::SendTalkChatroomMessageJob < ApplicationJob
    queue_as :default

=begin
@return [void]
@description
    This mehod is the responsable of the correct processing and execute of the Workflow Action. 
    In this method we replace the variables in the content and execute the action in its respective engine
    or log an activity of failure.

    The actual functionality of this action is to send an automatic message to an existing chat via CloudOne,
    and the result is visible on CloudTalk chatroom messages.
=end
    def perform(current_user, cloud_object, action)

        sender_user = nil

        case action.concerning_users["type"]
        when "creator"
            sender_user = cloud_object.user_creator
        when "main"
            sender_user = cloud_object.user_creator
        when "custom"
            sender_user = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
        when "current_user"
            sender_user = current_user
        end

        begin
            replacement_values = {
                "%global_identifier%" => cloud_object.global_identifier,
                "%current_user%" => (sender_user.full_name || "")
            }

            action.parse_input_data(replacement_values)
            input_data = action.input_data

            class_data = cloud_object.class.name.split("::")

            Courier::One::Firebase::Chatroom.send_message(
                sender_user,
                cloud_object.chatroom_external_id,
                input_data["message_text"]
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
