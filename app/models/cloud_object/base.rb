=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module CloudObject
    class Base < ApplicationLesliRecord
        self.abstract_class = true
        
        # @return [void]
        # @param bypass_new_record [Boolean] Wheter it workflow should be set in *cloud_objects* that are not finished yet or not
        # @description If the record is new, associates a new workflow with it using the workflow's method
        #     *set_workflow*
        # @example
        #     ticket = CloudHelp::Ticket.new(
        #         detail_attributes: {
        #             subject: 'Test',
        #             cloud_help_ticket_types_id: 1,
        #             cloud_help_ticket_categories_id: 1,
        #             cloud_help_ticket_priorities_id: 1
        #         }
        #     )
        #     ticket.set_workflow
        #     ticket.save!
        def set_workflow(bypass_new_record=false)
            if new_record? || bypass_new_record
                workflow_model = self.class.reflect_on_association(:status).klass.reflect_on_association(:workflow).klass                
                workflow_model.set_workflow(self)
            end
        end

        # @return [String]
        # @description Returns a string that represents and identifies this cloud_object from all other cloud_objects in the same account
        # @example
        #     project = CloudHouse::Project.find(1)
        #     puts projet.global_indentifier # If the CloudHouse::Project class does not have the method overrided, this wil print 'CloudHouse::Project - 1'
        def global_identifier
            return "#{self.class.name} - #{id}"
        end

        #######################################################################################
        ##############################  Activities Log Methods   ##############################
        #######################################################################################

        # @return [void]
        # @param current_user [::User] The user that created the cloud_object
        # @param cloud_object [CloudModule::Model] The cloud_object that was created
        # @description Creates an activity for this cloud_object indicating who created it.
        # Example
        #   params = {...}
        #   ticket = CloudHelp::Ticket.create(params)
        #   CloudHelp::Ticket.log_activity_create(User.first, ticket)
        def self.log_activity_create(current_user, cloud_object)
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
                    description: cloud_object.status.name,
                    field_name: "#{module_name}_workflow_statuses_id",
                    value_to: cloud_object.status.name
                )
            end
        end

        # @return [void]
        # @param current_user [::User] The user that showed the cloud_object
        # @param cloud_object [CloudModule::Model] The cloud_object that was showed
        # @description Creates an activity for this cloud_object indicating that someone viewed it.
        # Example
        #   ticket = CloudHelp::Ticket.find(1)
        #   CloudHelp::Ticket.log_activity_show(User.first, ticket)
        def self.log_activity_show(current_user, cloud_object)
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_show"
            )
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
        #   CloudHelp::Ticket.log_activity_update(User.find(1), ticket, old_attributes, new_attributes)
        def self.log_activity_update(current_user, cloud_object, old_attributes, new_attributes)
            # We remove values that are not tracked in the activities
            old_attributes.except!("id", "created_at", "updated_at", "deleted_at")
            old_attributes.each do |key, value|
                next if value == new_attributes[key]
                if key.include?("id")
                    if key == "user_main_id" || key == "users_id"
                        update_user_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key])
                    elsif key.include?("workflow_statuses_id")
                        update_workflow_status_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key])
                    else
                        update_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key])
                    end
                else
                    update_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key])
                end
            end
        end

        def self.update_field(cloud_object, current_user, key, old_field, new_field)
            old_field = LC::Date.to_string_datetime(old_field) if old_field.is_a?(Time) || old_field.is_a?(Date)
            new_field = LC::Date.to_string_datetime(new_field) if new_field.is_a?(Time) || new_field.is_a?(Date)

            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_update",
                field_name: key,
                value_from: old_field,
                value_to: new_field
            )
        end

        def self.update_user_field(cloud_object, current_user, key, old_user_id, new_user_id)
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_update",
                field_name: key,
                value_from: ::User.with_deleted.find(old_user_id).full_name,
                value_to:   ::User.with_deleted.find(new_user_id).full_name
            )
        end

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
        # @param current_user [::User] The user that deleted the cloud_object
        # @param cloud_object [CloudModule::Model] The cloud_object that was destroyed
        # @description Creates an activity for this cloud_object indicating that someone deleted it
        # Example
        #   ticket = CloudHelp::Ticket.find(1)
        #   CloudHelp::Ticket.log_activity_destroy(User.first, ticket)
        #   ticket.destroy
        def self.log_activity_destroy(current_user, cloud_object)
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_destroy"
            )
        end

    end
end
