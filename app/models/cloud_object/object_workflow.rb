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
@description Base abstract model for *Workflow* *Assignment* core entity

=end
    class ObjectWorkflow < ApplicationRecord
        self.abstract_class = true

=begin
@return [void]
@description Attempts to destroy an object_workflow. It will only allow it if the
    object_workflow has the 'global' field set to true
@example
    protected_workflow = CloudHouse::ProjectWorkflow.create(
        account: current_user.account,
        cloud_house_project_types_id: 1,
        cloud_house_workflows_id: 1
    )

    unprotected_workflow = CloudHouse::ProjectWorkflow.create(
        account: current_user.account,
        global: true,
        cloud_house_project_workflows_id: 1
    )
    
    unprotected_workflow.destroy! # Will not throw an error
    protected_workflow.destroy! # Will throw an error
=end
        def destroy
            if global
                super
            else
                errors.add(:base, :cannot_destroy_non_global_assignment)
                false
            end
        end

=begin
@return [void]
@description Attempts to create a global object_workflow. It will only allow it if there
    is no other global object workflow
@example
    workflow_1 = CloudHouse::ProjectWorkflow.create(
        account: current_user.account,
        global: true,
        cloud_house_workflows_id: 1
    ) # This will work

   workflow_2 = CloudHouse::ProjectWorkflow.create(
        account: current_user.account,
        global: true,
        cloud_house_workflows_id: 1
    ) # This will not work
    
=end
        def create
            if self.class.find_by(global: true, account: account)
                errors.add(:base, :global_workflow_already_exists)
                false
            else
                super
            end
        end

=begin
@param account [Account] Account to which the records are associated to
@param association_name [String] The name of the association that requested the assignments
@param association_id [Integer] The id of the associated record specified by *association_name*
@return [Array] Information about all the assignments, including workflow name, and associations names
@descriptions Retrieves all information about the assignments and returns it. If the assignments are associated
    to two or more tables, also retrieves important information for those association that are not the one
    provided in the *association_name* param 
@example
    puts CloudHelp::TicketWorkflow.detailed_info(current_user.account, 'ticket_type')
    # Will print something similar to 
    #[
    #    {
    #        "id":7,                                     "created_at":"2020-01-22T18:04:14.247Z",
    #        "updated_at":"2020-01-22T18:04:14.247Z",    "cloud_help_ticket_types_id":3,
    #        "cloud_help_ticket_categories_id":4,        "cloud_help_ticket_workflows_id":2,
    #        "cloud_help_accounts_id":1,                 "ticket_type_name":"Issue",
    #        "workflow_name":"Dummy Workflow"
    #    },{
    #        "id":8,                                     "created_at":"2020-01-22T18:04:14.250Z",
    #        "updated_at":"2020-01-22T18:04:14.250Z",    "cloud_help_ticket_types_id":3,
    #        "cloud_help_ticket_categories_id":5,        "cloud_help_ticket_workflows_id":2,
    #        "cloud_help_accounts_id":1,                 "ticket_type_name":"Issue",
    #        "workflow_name":"Dummy Workflow"
    #    },{
    #        "id":9,                                     "created_at":"2020-01-22T18:04:14.253Z",
    #        "updated_at":"2020-01-22T18:04:14.253Z",    "cloud_help_ticket_types_id":3,
    #        "cloud_help_ticket_categories_id":6,        "cloud_help_ticket_workflows_id":2,
    #        "cloud_help_accounts_id":1,                 "ticket_type_name":"Issue",
    #        "workflow_name":"Dummy Workflow"
    #    }
    #]
=end
        def self.detailed_info(account, association_name, association_id)
            module_name = dynamic_info[:module_name]

            workflow_assignments = self.where(
                "cloud_#{module_name}_accounts_id".to_sym => account.id,
                "cloud_#{module_name}_#{association_name.pluralize}_id".to_sym => association_id
            ).order(
                id: :asc
            )
            responses = []

            workflow_assignments.each do |assignment|

                response = assignment.attributes.merge({
                    workflow_name: assignment.workflow.name
                })
                self.associations.each do |association|
                    next if association[:name] == association_name

                    associated_record = association[:class].constantize.find(assignment[association[:key]])
                    responses.push(
                        response.merge({
                            "#{association[:name]}_#{association[:identifier]}" => associated_record[association[:identifier]]
                        })
                    )
                end
            end

            responses
        end

=begin
@return [Array] Information about the associations of a workflow to other tables
@description Returns a list of hashes, each Hash contains information about one association of a workflow.
    All hashes must contain a *name* (String), representing the name to which the belongs_to association is made,
    a *class* (String), that represents the full class to which this association belongs to, a *key* (Symbol)
    that represents the name of the foreign key field in the WorkflowAssociation model, and an *identifier* field,
    which is a field in the associated table that identifies that record from all others (since the id is not very
    intuitive)
@example
    # Imagine the current class is an instance of CloudHelp::TicketWorkflow < CloudObject::WorkflowAssignment
    puts self.associations.to_json
    # Will display
    #    [
    #        {
    #            "name": "ticket_category",
    #            "class": "CloudHelp::TicketCategory",
    #            "key": : "cloud_help_ticket_categories_id",
    #            "identifier": "name"
    #        },{
    #            "name": "ticket_type",
    #            "class": "CloudHelp::TicketType",
    #            "key': "cloud_help_ticket_types_id",
    #            "identifier": "name"
    #        }
    #    ]
=end
        def self.associations
            []
        end

        private

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::TicketWorkflowController < CloudObject::WorkflowAssignmentsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            cloud_object_name = module_info[1].sub("Workflow", "")
            {
                module_name: module_info[0].sub("Cloud", "").downcase
            }
        end
    end
end
    