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
module Shared
    class Workflow::Action < ApplicationLesliRecord
        self.abstract_class = true

        enum action_type: {
            send_core_email: "send_core_email",
            create_bell_notification: "create_bell_notification",
            create_focus_task: "create_focus_task", # This action can always be created, but it will only be executed if CloudFocus is available
            cloud_object_clone: "cloud_object_clone",
            create_cloud_object_file: "create_cloud_object_file",
            send_talk_chatroom_message: "send_talk_chatroom_message"
        }

        enum concerning_user_types: {
            creator: "creator", # The creator of the cloud_object
            main: "main", # The main user will be returned by calling the main_user() function in a cloud_object
            custom: "custom", # If this type is chosen, the user will input the concerning users manually
            current_user: "current_user" # If this type is chosen the selected user will be current_user
        }

        def self.list(workflow)
            dynamic_info_ = self.dynamic_info
            module_name = dynamic_info_[:module_name]
            full_module_name = dynamic_info_[:full_module_name].underscore

            workflow.actions.joins(
                "left join #{full_module_name}_workflow_statuses WSI on WSI.id = #{full_module_name}_workflow_actions.initial_status_id"
            ).joins(
                "inner join #{full_module_name}_workflow_statuses WSF on WSF.id = #{full_module_name}_workflow_actions.final_status_id"
            ).select(
                "#{full_module_name}_workflow_actions.id",
                "#{full_module_name}_workflow_actions.name",
                "WSI.name as initial_status_name",
                "WSF.name as final_status_name",
                "#{full_module_name}_workflow_actions.active",
                "#{full_module_name}_workflow_actions.action_type"
            ).order(id: :desc)
        end

        def show
            self
        end

        def self.options(current_user, workflow)
            statuses = {}
            workflow.statuses.order(number: :asc).each do |status|
                next_statuses = []
                if status.next_statuses
                    next_statuses = status.next_statuses.split("|").map do |nex_status|
                        nex_status.to_i
                    end
                end

                statuses[status.id] = {
                    id: status.id,
                    name: status.name,
                    number: status.number,
                    next_statuses: next_statuses
                }
            end
            
            {
                has_global_association: workflow.associations.find_by(global: true) != nil,
                concerning_user_types: self.concerning_user_types.map { |key,value| {value: key, text: value} },
                action_types: self.action_types.map { |key,value| {value: key, text: value} },
                statuses: statuses
            }
        end

        def self.execute_actions(current_user, cloud_object, old_attributes, new_attributes)
            dynamic_info_ = self.dynamic_info
            module_name = dynamic_info_[:module_name]
            full_module_name = dynamic_info_[:full_module_name].underscore
            
            initial_status_id = old_attributes["#{full_module_name}_workflow_statuses_id"]
            final_status_id = new_attributes["#{full_module_name}_workflow_statuses_id"]

            if final_status_id && final_status_id != initial_status_id
                
                workflow_actions = cloud_object.status.workflow_including_deleted.actions.where(active: true).where("
                    (final_status_id = ? and initial_status_id = ?) or
                    (final_status_id = ? and initial_status_id is ?)
                ", final_status_id, initial_status_id, final_status_id, nil)

                workflow_actions.each do |action|
                    action.execute(current_user, cloud_object)
                end
            end
        end

        def execute(current_user, cloud_object)
            case action_type
            when "create_focus_task"
                if execute_immediately
                    WorkflowActions::CreateFocusTaskJob.perform_now(current_user, cloud_object, self)
                else
                    WorkflowActions::CreateFocusTaskJob.perform_later(current_user, cloud_object, self)
                end
            when "create_bell_notification"
                if execute_immediately
                    WorkflowActions::CreateBellNotificationJob.perform_now(current_user, cloud_object, self)
                else
                    WorkflowActions::CreateBellNotificationJob.perform_later(current_user, cloud_object, self)
                end
            when "send_core_email"
                if execute_immediately
                    WorkflowActions::SendCoreEmailJob.perform_now(current_user, cloud_object, self)
                else
                    WorkflowActions::SendCoreEmailJob.perform_later(current_user, cloud_object, self)
                end
            when "cloud_object_clone"
                if execute_immediately
                    WorkflowActions::CloudObjectCloneJob.perform_now(current_user, cloud_object, self)
                else
                    WorkflowActions::CloudObjectCloneJob.perform_later(current_user, cloud_object, self)
                end
            when "create_cloud_object_file"
                if execute_immediately
                    Templates::CreateCloudObjectFileWithTemplateJob.perform_now(
                        current_user,
                        cloud_object,
                        Template::Document.find(self.input_data["template_id"]),
                        self.input_data["file_type"]
                    )
                else
                    Templates::CreateCloudObjectFileWithTemplateJob.perform_later(
                        current_user,
                        cloud_object,
                        Template::Document.find(self.input_data["template_id"]),
                        self.input_data["file_type"]
                    )
                end
            when "send_talk_chatroom_message"
                if execute_immediately
                    WorkflowActions::SendTalkChatroomMessageJob.perform_now(current_user, cloud_object, self)
                else
                    WorkflowActions::SendTalkChatroomMessageJob.perform_later(current_user, cloud_object, self)
                end
            end
        end

        # @return [Hash] Hash with the same information as the received hash, but with replaced data
        # @param replacement_values [Hash] A hash where the key is the text to be replaced, and the value is the replacement
        #   text
        # @description Replacements fields used as placeholders in the "input_data" field with values of the cloud_object
        # @example
        #   action = CloudHouse::Workflow::Action.first
        #   puts action.input_data["title"] # Let's asume this will print "A new task for project %global_identifier%"
        #   action.input_data = parse_input_data(action, {"%global_identifier%" => "12345"})
        #   puts action.input_data["title"] # Will print "A new task for project 12345
        def parse_input_data(replacement_values)
            replacement_values.each do |replacement_key, replacement_value|
                input_data.each do |input_key, input_value|
                    if input_value.instance_of? String
                        input_data[input_key] = input_value.gsub(replacement_key, replacement_value)
                    end
                end
            end
        end

        # @return [Hash] Hash with the information required to clone a cloud_object. If support for cloning the cloud_object
        # is not implemented, nil will be returned
        # @description This is a base function that must be overrided by the CloudEngine::Workflow::Action model that inherits from
        #   this model in order to implement it. Based on the first association of the received workflow, the options returned must be different
        # @example
        #   # Imagine the method is called without overriding it
        #   puts CloudHouse::Project::Workflow::Action.options_cloud_object_clone(CloudHouse::Workflow.find(1))
        #   # will display something like
        #   # {
        #     # fields: [
        #         # "cloud_house_properties_id",
        #         # "cloud_house_catalog_project_types_id",
        #         # "detail_attriburtes": [
        #         #     "code"
        #         # ]
        #     # ]
        #   # }
        def self.options_cloud_object_clone(current_user, workflow)
            return nil
        end

        def self.options_create_cloud_object_file(current_user, query, workflow)
            dynamic_info_ = self.dynamic_info
            engine_name = dynamic_info_[:engine_name]

            main_association = workflow.associations.order(id: :asc).first
            return nil unless main_association

            cloud_object_class = "#{engine_name}::#{main_association.workflow_for.capitalize}"

            
            # Temporariy Translations calculation this must be changed once real translation standards are implemented
            # @todo Change this once translations standars are set
            translations_class_name = (self.name.split("::")[0]).gsub("Cloud","").downcase
            translations_class_name = "deutscheleibrenten" if translations_class_name == "house"

            file_types = "#{cloud_object_class}::File".constantize.file_types.values.map do |file_type|
                {
                    value: file_type,
                    text: I18n.t("deutscheleibrenten.#{main_association.workflow_for}/files.enum_file_type_#{file_type}")
                    # text: I18n.t("#{translations_class_name}.#{main_association.workflow_for}/files.model_enum_file_type_#{file_type}")
                    
                }
            end

            {
                file_types: file_types,
                templates: Template::Document.where("model_type = ?", cloud_object_class)
            }
        end

        protected

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Workflow::Action < Shared::Workflow::Action
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            {
                module_name: module_name,
                full_module_name: module_info[0],
                engine_name: module_info[0]
            }
        end
    end
end
    