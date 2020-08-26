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
@description Base controller for *workflow* *statuses* core entity. A workflow status indicates
    which workflow belongs to which *cloud_object*
=end
    class Workflow::StatusesController < ApplicationLesliController
        before_action :set_workflow, only: [:index, :create]
        before_action :set_workflow_status, only: [:destroy]

=begin
@controller_action_param :workflow_for [String] The name of the *cloud_object* this workflow is assigned to
@controller_action_param :global [Boolean] Wheter this status is global or not
@return [Json] Json that contains wheter the creation of the workflow status was successful or not. 
    If it is not successful, it returns an error message
@description Creates a new workflow status associated to the *current_user*'s *account*
@example
# Executing this controller's action from javascript's frontend
    let workflow_id = 5;
    let data = {
        workflow_status: {
            workflow_form: "projects",
            global: true
        }
    };
    this.http.post('127.0.0.1/help/workflows/${workflow_id}/statuses', data);
=end
        def create
            return respond_with_not_found unless @workflow

            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            status = model.new(status_params)
            status.workflow = @workflow

            if status.save
                respond_with_successful(status)
            else
                respond_with_error(status.errors.full_messages.to_sentence)
            end
        end

private

=begin
@return [void]
@description Sets the variable @workflow. The variable contains the *cloud_object* *workflow* 
    to be handled by the controller action that called this method
@example
    #suppose params[:workflow_id] = 1
    puts @workflow # will display nil
    set_workflow
    puts @workflow # will display an instance of CloudHelp::Workflow
=end
        def set_workflow
            dynamic_info = self.class.dynamic_info
            workflow_model = dynamic_info[:workflow_model]
            module_name = dynamic_info[:module_name]

            @workflow = workflow_model.find_by(
                id: params[:workflow_id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

=begin
@return [void]
@description Sets the variable @workflow_assigned, along the variable @workflow.
    The variable contains the *workflow_status* to be handled by the controller action that called this method
@example
    # suppose params[:workflow_id] = 2
    # suppose params[:id] = 4
    puts @workflow # will display nil
    puts @workflow_status # will display nil
    set_workflow_status
    puts @workflow # will display an instance of CloudHelp::Workflow
    puts @workflow_status # will display an instance of CloudHelp::Workflow::Status
=end
        def set_workflow_status
            set_workflow
            @workflow_status = @workflow.statuses.find_by(id: params[:id])
        end

=begin
@return [Parameters] Allowed parameters for the workflow
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    If there are extra allowed params, they must be implemented on the subclass
@example
    # supose params contains {
    #    workflow_status: {
    #       workflow_for: 'projects'
    #       id: 10
    #    }
    #}
    filtered_params = status_params
    puts filtered_params
    # will remove the unpermitted params and only print {
    #       workflow_for: 'projects'
    #    }
=end
        def status_params
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            params.require(:workflow_status).permit(
                :next_statuses,
                :status_type,
                :name,
                :number
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Workflow::StatusesController < CloudObject::Workflow::StatusesController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:model].new # will return an instance of CloudHelp::Workflow::Status
    puts info[:workflow_model] # will return an instance of CloudHelp::Workflow
=end
        def self.dynamic_info
            module_info = lesli_classname().split("::")
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                model: "#{module_info[0]}::Workflow::Status".constantize,
                workflow_model: "#{module_info[0]}::Workflow".constantize
            }
        end
    end
end
    