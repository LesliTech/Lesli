class WorkflowActions::CloudObjectCloneJob < ApplicationJob
    queue_as :default

    def perform(current_user, cloud_object, action)
        user_main = nil
        case action.concerning_users["type"]
        when "creator"
            user_main = cloud_object.user_creator
        when "main"
            user_main = cloud_object.user_main
        when "branch_office"
            user_main = cloud_object.user_branch_office
        when "custom"
            user_main = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
        when "current_user"
            user_main = current_user
        end

        # Sanity check. If the association doesn't exist, or it is not a user, we default back to current_user
        user_main = current_user unless user_main

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

            new_cloud_object_attributes = {}
            new_cloud_object_detail_attributes = {}
            
            # We either copy the attribute name from old resource to new resource or assign the default value
            cloud_object.class.attribute_names.each do |attribute_name|

                # If this condition is fulfilled, the table is capable of recursive reference and the user wants to create it
                if attribute_name == "#{cloud_object.class.table_name}_id" && input_data["add_reference"]
                    new_cloud_object_attributes[attribute_name.to_sym] = cloud_object.id
                end

                case input_data[attribute_name]
                when "copy"
                    new_cloud_object_attributes[attribute_name.to_sym] = cloud_object[attribute_name.to_sym]
                when "custom"
                    new_cloud_object_attributes[attribute_name.to_sym] = input_data["#{attribute_name}_custom_value"]
                end
            end

            # We do the same with the detail model
            detail_model = "#{cloud_object.class.name}::Detail".constantize
            detail_model.attribute_names.each do |attribute_name|
                case input_data[attribute_name]
                when "copy"
                    new_cloud_object_detail_attributes[attribute_name.to_sym] = cloud_object.detail[attribute_name.to_sym]
                # In the case the user selects serial, the serial value is calculating using the foreign keys of the main table
                when "serial"
                    serial_value = 1

                    latest_object = cloud_object.class.joins(:detail)
                    new_cloud_object_attributes.each do |key, value|
                        latest_object = latest_object.where(key.to_sym => value)
                    end
                    latest_object = latest_object.order("#{detail_model.table_name}.#{attribute_name} desc").first
                    
                    if latest_object
                        serial_value = latest_object.detail[attribute_name.to_sym] + 1
                    end

                    new_cloud_object_detail_attributes[attribute_name.to_sym] = serial_value
                when "custom"
                    new_cloud_object_detail_attributes[attribute_name.to_sym] = input_data["#{attribute_name}_custom_value"]
                end
            end

            # We create the cloud_object, add workflows and activities
            new_cloud_object = cloud_object.class.new(
                new_cloud_object_attributes.merge({
                    user_main: user_main,
                    detail_attributes: new_cloud_object_detail_attributes,
                    user_creator: current_user,
                    account: cloud_object.account
                })
            )

            new_cloud_object.set_workflow

            new_cloud_object.save
            new_cloud_object.clone_associations(cloud_object)

            actions_class = "#{new_cloud_object.status.workflow.class}::Action".constantize
            actions_class.execute_actions(current_user, new_cloud_object, {}, new_cloud_object.attributes)

            new_cloud_object.activities.create!(
                category: "action_create",
                user_creator: current_user
            )

            new_cloud_object.activities.create!(
                user_creator: current_user,
                category: "action_status",
                description: new_cloud_object.status.name,
                field_name: "#{new_cloud_object.status.class.table_name}_id",
                value_to: new_cloud_object.status.name
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
