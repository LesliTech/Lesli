module CloudObject
=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Base abstract model for *Workflow* *actions* core entity used for workflows

=end
    class Workflow::Action < ApplicationRecord
        self.abstract_class = true

        enum action_type: {
            send_core_email: "send_core_email",
            generate_core_document: "generate_core_document",
            create_focus_task: "create_focus_task" # This action can always be created, but it will only be executed if CloudFocus is available
        }

        enum concerning_user_types: {
            main: "main", # The main user will be returned by calling the main_user() function in a cloud_object
            employee: "employee", # If this type is chosen, the user will select the concerning user(s) from the employee list
            custom: "custom", # If this type is chose, the user will input the concerning users email (this type may be disabled for some cloud_actions)
        }

        def self.execute_actions(current_user, cloud_object, old_attributes, new_attributes)
            dynamic_info_ = self.dynamic_info
            module_name = dynamic_info_[:module_name]
            
            initial_status_id = old_attributes["cloud_#{module_name}_workflow_statuses_id"]
            final_status_id = new_attributes["cloud_#{module_name}_workflow_statuses_id"]

            if final_status_id && initial_status_id && final_status_id != initial_status_id
                workflow = cloud_object.status.workflow

                workflow_actions = workflow.actions.where(final_status_id: final_status_id, initial_status_id: initial_status_id)

                workflow_actions.each do |action|
                    action.execute(current_user, cloud_object)
                end
            end
        end

        def execute(current_user, cloud_object)
            case action_type
            when "create_focus_task"
                return execute_create_focus_task(current_user, cloud_object)
            end
        end

        protected

        def execute_create_focus_task(current_user, cloud_object)

            task_employee = nil
            case concerning_users["type"]
            when "main"
                task_employee = cloud_object.get_main_employee
            when "employee"
                task_employee = ::Courier::Core::User.get(concerning_users["list"][0]) if concerning_users["list"]
            end
            return unless task_employee # There is no task employee, so this action cannot be fufilled @todo: Log Error Activity

            task_params = {
                user: task_employee,
                model_type: cloud_object.class.name,
                model_id: cloud_object.id,
                detail_attributes: {
                    title: input_data["title"],
                    description: input_data["description"],
                    deadline: LC::Date.now + (input_data["days_until_deadline"] || 0).days,
                    importance: input_data["importance"],
                    task_type: input_data["task_type"],
                }
            }
            ::Courier::Focus::Task.tasks_new(current_user, task_params, execute_immediately, configuration["send_email"])
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Workflow::Action < CloudObject::Workflow::Action
    info = dynamic_info
    puts info[:module_name] # will print 'help'
=end
        def self.dynamic_info
            module_info = self.name.split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            module_name = "house" if module_name == "haus"
            {
                module_name: module_name
            }
        end
    end
end
    