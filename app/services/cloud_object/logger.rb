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





=begin

** IMPORTANT **

Avoid using this class for logging cloud_object activity. The correct implementation is to set CloudObject
as the parent class for your model and use the methods provided:
- log_activity_create
- log_activity_update
- log_activity_destroy

You are free to add custom loggers to you model for custom actions.

=end




class CloudObject::Logger

    # @return [void]
    # @param current_user [::User] The user that created the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that was created
    # @description Creates an activity for this cloud_object indicating who created it.
    # Example
    #   params = {...}
    #   ticket = CloudHelp::Ticket.create(params)
    #   CloudHelp::Ticket.log_create(User.first, ticket)
    def self.log_create(current_user, cloud_object)
        LC::Debug.deprecation("please use CloudObject.log_activity_create or your own implementation on the model instead")

        cloud_object.activities.create(
            user_creator: current_user,
            category: "action_create"
        )

        # If cloud_object has workflow
        if defined?(cloud_object.status)
            module_name = cloud_object.class.lesli_classname().split("::")[0].underscore
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_status",
                description: cloud_object.status&.name,
                field_name: "#{module_name}_workflow_statuses_id",
                value_to: cloud_object.status&.name
            )
        end
    end

    # @return [void]
    # @param current_user [::User] The user that edited the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that was edited
    # @param old_attributes[Hash] The data of the record before update
    # @param new_attributes[Hash] The data of the record after update
    # @description Creates an activity for this cloud_object if someone changed any of this values
    # Example
    #   ticket = CloudHelp::Ticket.find(1)
    #   old_attributes  = ticket.attributes
    #   ticket.update(user_main: User.find(33))
    #   new_attributes = ticket.attributes
    #   CloudHelp::TicketLogger.log_update(User.find(1), ticket, old_attributes, new_attributes)
    def self.log_update(current_user, cloud_object, old_attributes, new_attributes, category: "action_update")
        LC::Debug.deprecation("please use CloudObject.log_activity_update or your own implementation on the model instead")

        # We remove values that are not tracked in the activities
        old_attributes.except!("id", "created_at", "updated_at", "deleted_at")
        old_attributes.each do |key, value|
            next if value == new_attributes[key]
            if key.include?("id")
                if key == "user_main_id" || key == "users_id" || key == "user_branch_office_id"
                    update_user_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key], category)
                elsif key.include?("workflow_statuses_id")
                    update_workflow_status_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key])
                else
                    update_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key], category)
                end
            else
                update_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key], category)
            end
        end
    end

    # @return [void]
    # @param current_user [::User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that was destroyed
    # @description Creates an activity for this cloud_object indicating that someone deleted it
    # Example
    #   ticket = CloudHelp::Ticket.find(1)
    #   CloudHelp::TicketLogger.log_destroy(User.first, ticket)
    #   ticket.destroy
    def self.log_destroy(current_user, cloud_object)
        LC::Debug.deprecation("please use CloudObject.log_activity_destroy or your own implementation on the model instead")

        cloud_object.activities.create(
            user_creator: current_user,
            category: "action_destroy"
        )
    end

    protected

    # @return [void]
    # @param current_user [User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that updated
    # @param key [String] The user field to be logged
    # @param old_user_id [Integer] The id of the user prior to the update
    # @param new_user_id [Integer] The id of the user after the update
    # @description Logs an "action_update" activity. But instead of using the raw id of the user, it logs their name
    # @example
    #     project = CloudHouse::Project.first
    #     CloudHouse::ProjectLogger.log_update(User.first, project, "users_id", 1, 2)
    #     # This will log a change from user with id 1 to user with id 2 using their names
    def self.update_user_field(cloud_object, current_user, key, old_user_id, new_user_id, category)
        cloud_object.activities.create(
            user_creator: current_user,
            category: category,
            field_name: key,
            value_from: old_user_id ? User.with_deleted.find(old_user_id).full_name : nil,
            value_to:   new_user_id ? User.with_deleted.find(new_user_id).full_name : nil
        )
    end

    # @return [void]
    # @param current_user [User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that updated
    # @param key [String] The user field to be logged
    # @param old_workflow_status_id [Integer] The id of the workflow status prior to the update
    # @param new_workflow_status_id [Integer] The id of the workflow status after the update
    # @description Logs an "action_update" activity. But instead of using the raw id of the workflow status, it logs its name
    # @example
    #     project = CloudHouse::Project.first
    #     CloudHouse::ProjectLogger.log_update(User.first, project, "cloud_house_workflow_statuses_id, 1, 2)
    #     # This will log a change from workflow status with id 1 to workflow status with id 2 using their names
    def self.update_workflow_status_field(cloud_object, current_user, key, old_workflow_status_id, new_workflow_status_id)
        module_name = cloud_object.class.lesli_classname().split("::")[0]
        old_status = eval("#{module_name}::Workflow::Status").with_deleted.find(old_workflow_status_id).name
        new_status = eval("#{module_name}::Workflow::Status").with_deleted.find(new_workflow_status_id).name

        cloud_object.activities.create(
            user_creator: current_user,
            description: new_status,
            category: "action_status",
            field_name: key,
            value_from: old_status,
            value_to:   new_status
        )
    end

    # @return [void]
    # @param current_user [User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that updated
    # @param key [String] The user field to be logged
    # @param old_field [Integer] The value of the field prior to the update
    # @param new_field [Integer] The value of the field after the update
    # @description Logs an "action_update" activity. If the value that changed is a date, it uses LC::Date to turn it into a string
    #     otherwise, it logs it as is
    # @example
    #     ticket = CloudHelp::Ticket.first
    #     CloudHelp::TicketLogger.log_update(User.first, ticket, "deadline": Time.now - 1.days, Time.now)
    #     # This will log a change from workflow on the deadline, and it will use the format specified by the lesli instance
    def self.update_field(cloud_object, current_user, key, old_field, new_field, category)
        old_field = LC::Date.to_string_datetime(old_field) if old_field.is_a?(Time) || old_field.is_a?(Date)
        new_field = LC::Date.to_string_datetime(new_field) if new_field.is_a?(Time) || new_field.is_a?(Date)

        cloud_object.activities.create(
            user_creator: current_user,
            category: category,
            field_name: key,
            value_from: old_field,
            value_to: new_field
        )
    end
end
