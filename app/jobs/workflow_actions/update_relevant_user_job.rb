class WorkflowActions::UpdateRelevantUserJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        input_data = action.input_data

        input_data["relevant_user_flags"].each do |key, value|
            next unless value

            begin
                if value == "current_user"
                    cloud_object.update!(key.to_sym => current_user)
                elsif value == "custom"
                    cloud_object.update!(key.to_sym => current_user.account.users.find(input_data["relevant_user_values"][key]["id"]))
                else
                    cloud_object.update!(key.to_sym => cloud_object.send("user_#{value}"))
                end

                # If there is a timestamp, we update it
                if cloud_object.class.column_names.include? "#{key}_id_updated_at"
                    cloud_object.update!("#{key}_id_updated_at".to_sym => LC::Date.now)
                end

            rescue StandardError => e
                cloud_object.activities.create(
                    user_creator: current_user,
                    category: "action_workflow_action_failed",
                    description: "Error while updating: #{key}: #{e.message}"
                )
            end
            
        end
    end
end
