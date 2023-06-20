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
module Shared
    class Workflow::StatusesController < ApplicationLesliController
        before_action :set_workflow, only: [:index, :create]
        before_action :set_workflow_status, only: [:destroy]

        def index
            return respond_with_not_found unless @workflow

            respond_with_successful(@workflow.statuses)
        end

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
            full_module_name = dynamic_info[:full_module_name].underscore

            @workflow = workflow_model.find_by(
                id: params[:workflow_id],
                "#{full_module_name}_accounts_id".to_sym => current_user.account.id
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
    # Imagine the current class is an instance of CloudHelp::Workflow::StatusesController < Shared::Workflow::StatusesController
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
                full_module_name: module_info[0],
                model: "#{module_info[0]}::Workflow::Status".constantize,
                workflow_model: "#{module_info[0]}::Workflow".constantize
            }
        end
    end
end
    