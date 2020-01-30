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
@description Base controller for the *workflow* *assignment* core entity. This controller
    will manage associations between a *workflow* and its *cloud_object*.
=end
    class ObjectWorkflowsController < ApplicationLesliController

        before_action :set_object_workflow, only: :update

=begin
@return [HTML|JSON] HTML view for listing all workflow assignments or a Json that contains a list 
    of all workflow assignments associated to this *account*
@description Retrieves and returns all workflow assignments associated to a *CloudHelp::Account*. 
    The account is obtained directly from *current_user*. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    this.http.get('127.0.0.1/help/ticket_workflow_assignments');
=end
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    dynamic_info = self.class.dynamic_info
                    model = dynamic_info[:model]
                    
                    responseWithSuccessful(model.detailed_info(current_user.account, params[:name], params[:resource_id])) 
                end
            end
        end

        def workflow_options
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]
            responseWithSuccessful(model.associations)
        end

        def update
            return responseWithNotFound unless @workflow_assignment
            if @workflow_assignment.update(object_workflow_params)
                responseWithSuccessful(@workflow_assignment)
            else
                responseWithError(@workflow_assignment.errors.full_messages.to_sentence)
            end
        end

        private

=begin
@return [void]
@description Sets the variable @workflow_assignment. The variable contains the *workflow* *assignment* 
    to be handled by the controller action that called this method
@example
    #suppose params[:id] = 1 and controller is CloudHelp::TicketWorkflowsController
    puts @workflow_assignment # will display nil
    set_state
    puts @workflow_assignment # will display an instance of CloudHelp:TicketWorkflowAssignment
=end
        def set_object_workflow
            dynamic_info = self.class.dynamic_info

            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]

            @workflow_assignment = model.find_by(
                id: params[:id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

=begin
@return [Parameters] Allowed parameters for the workflow_assignment
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    Allowed params are :cloud_[cloud_module_name]_[cloud_object_name]_workflows_id
@example
    # supose params contains {
    #    "workflow_assignment": {
    #        "id": 5,
    #        "cloud_help_ticket_workflows_id": 5,
    #        "cloud_help_ticket_types_id": 9
    #    }
    #}
    filtered_params = object_workflow_params
    puts filtered_params
    # will only print {
    #    "cloud_help_ticket_workflows_id": 5
    #}
=end
        def object_workflow_params
            dynamic_info = self.class.dynamic_info

            module_name = dynamic_info[:module_name]
            cloud_object_name = dynamic_info[:cloud_object_name]
            object_name = dynamic_info[:object_name]

            params.fetch(object_name.to_sym, {}).permit("cloud_#{module_name}_workflows_id".to_sym)
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::TicketWorkflowsController < CloudObject::ObjectWorkflowsController
    info = CloudHelp::TicketWorkflowsController.dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:object_name] # will print 'ticket_workflow'
    info[:cloud_object_name] # will print 'ticket'
    info[:model].new # will print an instance of CloudHelp::TicketWorkflow
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            cloud_object_name = module_info[1].sub("WorkflowsController", "")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: "#{cloud_object_name.downcase}_workflow",
                cloud_object_name: cloud_object_name.downcase,
                model: "#{module_info[0]}::#{cloud_object_name}Workflow".constantize
            }
        end
    end
end
    