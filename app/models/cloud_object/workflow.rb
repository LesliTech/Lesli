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
@description Base abstract model for *Workflow* *state* core entity used for workflows

=end
    class Workflow < ApplicationRecord
        self.abstract_class = true

        after_update :verify_default_workflow

=begin
@return [Boolean] Wheter the workflow was deleted or not
@description Attempts to delete this workflow.
    However, if there is a *cloud_object* associated to this *workflow*, it 
    will not be deleted and an error will be added to the *errors* parameter
@example
    my_workflow = CloudHelp::Workflow.first
    if my_workflow.destroy
        puts "workflow successfully destroyed"
    else
        puts "workflow was not destroyed"
        puts my_workflow.errors.full_messages.to_sentence
    end
=end
        def destroy
            if default
                errors.add(:base, :cannot_delete_default_workflow)
                false
            else
                begin
                    super
                rescue ActiveRecord::InvalidForeignKey
                    errors.add(:base, :foreign_key_prevents_destruction)
                    false
                end
            end
        end

=begin
@return [Hash] Hash of containing the information of the workflow and its statuses. 
@description Returns a hash with information about the workflow and all its *statuses* 
    that contain the transitions between *states*
@example
    workflow = CloudHelp::Workflow.first.full_workflow
    responseWithSuccessful(workflow)
=end
        def detailed_info
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            status_model = dynamic_info[:status_model]

            data = {}
            nodes = status_model.select(
                :id,
                :name,
                :number,
                :initial,
                :final,
                :next_statuses
            ).where(
                workflow: self
            ).order(
                number: :asc
            )

            next_number = 0
            nodes.each do |node|
                node = node.attributes
                next_number = node["number"] + 1
                node["visited"] = false
                data[node["number"]] = node
            end

            {
                id: id,
                name: name,
                next_number: next_number,
                default: default,
                created_at: created_at,
                updated_at: updated_at,
                statuses: data
            }
        end

=begin
@param account [Account] Account from current user
@return [Array] Array of workflows. 
@description Retrieves and returns all workflows from an *Account*.
    Each workflow contains only the fields to be displayed in
    a table
@example
    account = current_user.account
    workflows = CloudHelp::Workflow.detailed_info(account)
=end
        def self.detailed_info(account)
            module_name = dynamic_info[:module_name]

            self.where(
                "cloud_#{module_name}_accounts_id".to_sym => account.id
            ).select(
                :id,            :default,
                :name,          :created_at,
                :updated_at
            )
        end

=begin
@return [Array] Information about all the cloud objects that can have workflows
@description Based on the *cloud_objects* method of the workflow class, generates information
    about the class of the cloud_object, the endpoind, and it's name, so the user can
    associate it properly
@example
    workflow = CloudHouse::Workflow.find_by(1)
    puts workflow.global_assignments.to_json # Will print something like
    #[
    #    {
    #        "name":"Properties",
    #        "url":"/house/property_workflows",
    #        "params_name":"property_workflow",
    #        "id":6,
    #        "assigned":true
    #    }, {
    #        "name":"Projects",
    #        "url":"/house/project_workflows",
    #        "params_name":"project_workflow",
    #        "assigned":false
    #    }
    #]
=end
=begin
        def global_assignments
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            assignments = []
            
            cloud_objects.each do |cloud_object_classname|
                object_workflow_model = "#{cloud_object_classname}Workflow".constantize rescue nil
                next unless object_workflow_model

                cloud_object_name = cloud_object_classname.split("::")[-1]
                assignment = {
                    name: cloud_object_name.pluralize,
                    url: "/#{module_name}/#{cloud_object_name.downcase}_workflows",
                    params_name: "#{cloud_object_name.downcase}_workflow"
                }

                global_entry = object_workflow_model.find_by(
                    account: account,
                    global: true,
                    "cloud_#{module_name}_workflows_id": id
                )
                
                if global_entry
                    assignment[:id] = global_entry.id
                    assignment[:assigned] = true
                else
                    assignment[:assigned] = false
                end

                assignments.push(assignment)
            end

            assignments
        end
=end

        protected
        
=begin
@return [void]
@description Checks if a workflow was changed to default. If it was, marks the previously
    default workflow as not detault. If it is unable to do it, raises an exception that
    triggers a rollback
=end
        def verify_default_workflow
            default_change = saved_changes["default"]
            return unless default_change
            
            if default_change[1]
                # default changed from false to true
                raise ActiveRecord::RecordInvalid, self unless self.class.where(
                    default: true,
                    account: account
                ).where.not(id: id).update(default: false)
            end
        end

        
=begin
@return [void]
@description Adds the "workflow_detail" attribute to an existing *cloud_object*.
    The detail added is the one associated to the *initial* *state*, based on the
    *cloud_object*'s attributes configured as associations in the *workflow_assignment*
    model.
@example
    ticket_params = {
        detail_attributes: {
            cloud_help_ticket_priorities_id: 1,
            cloud_help_ticket_categories_id: 1,
            cloud_help_ticket_types_id: 1
        }
    }
    ticket = CloudHelp::Ticket.new(ticket_params)
    CloudHelp::Workflow.set_workflow(ticket)
    if ticket.save
        responseWithSuccessful
    else
        responseWithError(ticket.errors.full_messages.to_sentence)
    end
=end
=begin
        def self.set_workflow(cloud_object)

            dynamic_info_ = self.dynamic_info
            assignment_model = dynamic_info_[:assignment_model]
            detail_model = dynamic_info_[:detail_model]
            status_model = dynamic_info_[:status_model]
            account = cloud_object.account


            cloud_object_name = cloud_object.class.name.split("::")
            assignment_model = "#{cloud_object_name[0]}::#{cloud_object_name[1]}Workflow".constantize

            # Global Workflow
            workflow_assignment = assignment_model.find_by(global: true)

            # Specific Workflow
            associations = assignment_model.associations rescue nil
            if associations 
                search_params = {
                    account: account
                }
                
                associations.each do |association|
                    search_params["#{association[:name]}".to_sym] = cloud_object[association[:key]]
                end

                workflow_assignment = assignment_model.find_by(search_params)
            end
            
            if workflow_assignment 
                workflow = workflow_assignment.workflow

                cloud_object.workflow_detail = detail_model.find_by(
                    workflow: workflow,
                    workflow_state: status_model.initial_state(account)
                )
            end
        end
=end

=begin
@return [void]
@param account [Cloud[module_name]::Account] The account associated to this workflow
@description Initializes the default dummy workflow of the account. This method should be
    called as an after_create method in the account model.
@example
    house_account = CloudHouse::Account.new(::Account.find(1))
    # Rails will automatically execute an after_create method in the account model, and
    # that method will execute this method
=end
        def self.initialize(account)
            dynamic_info = self.dynamic_info
            module_name = dynamic_info[:module_name]

            self.create(
                name: 'Default Workflow',
                default: true,
                account: account,
                statuses_attributes: [
                    {
                        name: 'created',
                        number: 0,
                        initial: true,
                        next_statuses: '1'
                    },
                    {
                        name: 'closed',
                        number: 1,
                        final: true
                    }
                ]
            )
        end

        private
        
=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Workflow.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:status_model].new # will print a new instance of CloudHelp::Workflow::Status
    puts dynamic_info[:status_model] # will print a new instance of CloudHelp::WorkflowState
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                status_model: "#{self.name}::Status".constantize
            }
        end
    end
end
