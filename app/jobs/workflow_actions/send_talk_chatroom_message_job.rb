=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

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
            sender_user = cloud_object.user_main
        when "branch_office"
            sender_user = cloud_object.user_branch_office
        when "custom"
            sender_user = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
        when "current_user"
            sender_user = current_user
        end

        # Sanity check. If the association doesn't exist, or it is not a user, we default back to current_user
        sender_user = current_user unless sender_user

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

            message_params = {
                sender_user: sender_user,
                chatroom_uid: cloud_object.chatroom_external_id,
                message_text: input_data["message_text"]
            }

            Courier::Talk::Chatroom.send_message(current_user, message_params)

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
