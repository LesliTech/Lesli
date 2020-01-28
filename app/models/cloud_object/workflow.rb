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
@return [Hash] Hash of containing the information of the workflow and its details. 
@description Returns a hash with information about the workflow and all its *details* 
    that contain the transitions between *states*
@example
    workflow = CloudHelp::Workflow.first.full_workflow
    responseWithSuccessful(workflow)
=end
        def full_workflow
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            detail_model = dynamic_info[:detail_model]

            data = {}
            nodes = detail_model.joins(
                :workflow
            ).joins(
                :workflow_state
            ).select(
                "cloud_#{module_name}_workflow_details.id",
                "cloud_#{module_name}_workflow_states.initial",
                "cloud_#{module_name}_workflow_states.final",
                "cloud_#{module_name}_workflow_details.next_states",
                "cloud_#{module_name}_workflow_states.id as workflow_state_id",
                "cloud_#{module_name}_workflow_states.name as workflow_state_name"
            ).where(
                "cloud_#{module_name}_workflows.id = #{id}"
            )

            nodes.each do |node|
                node = node.attributes
                node["visited"] = false
                data[node["workflow_state_id"]] = node
            end

            {
                name: name,
                default: default,
                created_at: created_at,
                updated_at: updated_at,
                details: data
            }
        end

=begin
@param account [Account] Account from current user
@param new_workflow [Hash] A hash containing all the information of the
    changes made to the workflow in the same format as the rails standard
@return [Boolean] Whether the workflow was successfully updated or not
@description Updates the workflow with new states and transitions. The detail 
    associated with the *final* *state* can never change. The detail associated
    with the *initial* *state* can only change it's transitions, and all other
    details are destroyed and reinserted in the database. If an error ocurrs,
    a message is added to the *errors* param of the workflow
@example
    workflow_data  = {
        workflow:{
            cloud_help_slas_id:1,
            "details_attributes:[
                {
                    id:1,
                    next_states:"4",
                    workflow_state_id:1
                },{
                    id:2,
                    next_states:null
                    workflow_state_id:2
                },{
                    id:14,
                    next_states:"2",
                    workflow_state_id:4
                }
            ]
        }
    }
    workflow = CloudHelp::Workflow.find(4)
    if workflow.replace_workflow(workflow_data)
        puts "Workflow was successfully replaced"
    else
        puts "Workflow was not replaced"
        puts workflow.errors.full_messages.to_sentence
    end
=end
        def replace_workflow(account, new_workflow)
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            state_model = dynamic_info[:state_model]

            begin
                initial_state_id = state_model.initial_state(account).id
                final_state_id = state_model.final_state(account).id
                details.where(
                    "cloud_#{module_name}_workflow_states_id != #{initial_state_id}"
                ).where(
                    "cloud_#{module_name}_workflow_states_id != #{final_state_id}"
                ).destroy_all

                state_id_key = "cloud_#{module_name}_workflow_states_id".to_sym
                new_workflow.each do |node|
                    # created or closed
                    if node[state_id_key] == initial_state_id || node[state_id_key] == final_state_id
                        details.where(id: node[:id]).update(next_states: node[:next_states])
                    else
                        details.create(
                            state_id_key => node[state_id_key],
                            next_states: node[:next_states]
                        )
                    end
                end
            rescue ActiveRecord::InvalidForeignKey
                errors.add(:base, :foreign_key_prevents_destruction)
                false
            end
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
                raise ActiveRecord::RecordInvalid, self unless self.class.where(default: true).where.not(id: id).update(default: false)
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
        def self.set_workflow(cloud_object)

            dynamic_info_ = self.dynamic_info
            assignment_model = dynamic_info_[:assignment_model]
            detail_model = dynamic_info_[:detail_model]
            state_model = dynamic_info_[:state_model]
            account = cloud_object.account


            cloud_object_name = cloud_object.class.name.split("::")
            assignment_model = "#{cloud_object_name[0]}::#{cloud_object_name[1]}WorkflowAssignment".constantize

            associations = assignment_model.associations
            search_params = {account: account}
            
            associations.each do |association|
                search_params["#{association[:name]}".to_sym] = cloud_object.detail[association[:key]]
            end

            workflow_assignment = assignment_model.find_by(search_params)
            workflow = workflow_assignment.workflow

            cloud_object.detail.workflow_detail = detail_model.find_by(
                workflow: workflow,
                workflow_state: state_model.initial_state(account)
            )
        end

        private
        
=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Workflow.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:detail_model].new # will print a new instance of CloudHelp::Workflow::Detail
    puts dynamic_info[:state_model] # will print a new instance of CloudHelp::WorkflowState
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                detail_model: "#{self.name}::Detail".constantize,
                state_model: "#{module_info[0]}::WorkflowState".constantize
            }
        end
    end
end
