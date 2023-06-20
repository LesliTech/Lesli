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
    class Workflow::ChecksController < ApplicationLesliController
        before_action :set_workflow, only: [:index, :create, :options]
        before_action :set_workflow_check, only: [:update, :destroy]

        # @return [HTML|JSON] HTML view for listing all workflow checks or a Json that contains a list 
        #     of all workflow checks associated to this *account* and *workflow*
        # @description Retrieves and returns all workflow checks associated to a *CloudEngine::Account*. 
        #     The account is obtained directly from *current_user*. The HTTP request has to specify
        #     wheter the HTML or the JSON text should be rendered
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let workflow_id = 4;
        #     this.http.get(`127.0.0.1/help/workflows/${workflow_id}/checks`);
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    return respond_with_not_found unless @workflow

                    dynamic_info = self.class.dynamic_info
                    model = dynamic_info[:model]
                    
                    respond_with_successful(model.index(@workflow))
                end
            end
        end

        # @controller_action_param :name [String] The name of the *check*
        # @controller_action_param :active [Boolean] Defaults to false. Indicates if the check is to be ignored or not
        # @controller_action_param :initial_status_id [BigInt] The id of the status in which the check will initiate (can be empty)
        # @controller_action_param :final_status_id [BigInt] The id of the status in which the check will end (can be empty)
        # @controller_action_param :users_id [BigInt] The id of the user that is allowed to pass this check
        # @controller_action_param :roles_id [BigInt] The id of the role that is allowed to pass this check
        # @return [Json] Json that contains wheter the creation of the workflow check was successful or not. 
        #     If it is not successful, it returns an error message
        # @description Creates a new workflow check associated to the *current_user*'s *account* and *workflow*
        # @example
        # # Executing this controller's action from javascript's frontend
        #     let workflow_id = 5;
        #     let data = {
        #         workflow_check: {
        #             name: "Vacation Verification",
        #             active: true,
        #             initial_status_id: 4,
        #             roles_id: 4
        #         }
        #     };
        #     this.http.post('127.0.0.1/team/workflows/${workflow_id}/checks', data);
        def create
            return respond_with_not_found unless @workflow

            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            check = @workflow.checks.new(check_params)

            if check.save
                respond_with_successful(check)
            else
                respond_with_error(check.errors.full_messages.to_sentence)
            end
        end

        def show
            respond_to do |format|
                format.json do
                    set_workflow_check
                    return respond_with_not_found unless @workflow_check
                    
                    respond_with_successful(@workflow_check.show(current_user, @query))
                end
            end
        end

        # @controller_action_param :name [String] The name of the *check*
        # @controller_action_param :active [Boolean] Defaults to false. Indicates if the check is to be ignored or not
        # @controller_action_param :initial_status_id [BigInt] The id of the status in which the check will initiate (can be empty)
        # @controller_action_param :final_status_id [BigInt] The id of the status in which the check will end (can be empty)
        # @controller_action_param :users_id [BigInt] The id of the user that is allowed to pass this check
        # @controller_action_param :roles_id [BigInt] The id of the role that is allowed to pass this check
        # @return [Json] Json that contains wheter the update of the workflow check was successful or not. 
        #     If it is not successful, it returns an error message
        # @description Updates an existing workflow check associated to the *current_user*'s *account* and *workflow*
        # @example
        # # Executing this controller's action from javascript's frontend
        #     let workflow_id = 5;
        #     let check_id = 45;
        #     let data = {
        #         workflow_check: {
        #             name: "Vacation Verification",
        #             active: true,
        #             initial_status_id: 4,
        #             roles_id: 4
        #         }
        #     };
        #     this.http.put('127.0.0.1/team/workflows/${workflow_id}/checks/${check_id}', data);
        def update
            return respond_with_not_found unless @workflow_check

            if @workflow_check.update(check_params)
                respond_with_successful(@workflow_check)
            else
                respond_with_error(@workflow_check.errors.full_messages.to_sentence)
            end
        end

        # @return [Json] Json that contains wheter the workflow was successfully deleted or not. 
        #     If it it not successful, it returns an error message
        # @description Deletes an existing *workflow* associated to the *current_user*'s *account*.
        #     Since the workflow has details, these are also deleted. However, if there
        #     is an existing *cloud_object* associated to the *workflow*, it cannot be deleted
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let workflow_id = 4;
        #     let check_id = 9;
        #     this.http.delete(`127.0.0.1/help/workflows/${workflow_id}/checks/${check_id}`);
        def destroy
            return respond_with_not_found unless @workflow_check

            if @workflow_check.destroy
                respond_with_successful
            else
                respond_with_error(@workflow_check.errors.full_messages.to_sentence)
            end
        end


        # @return [JSON] A list of global checks of the workflow
        # @description Obtains a list of all the global checks of this workflow. A global check
        #     is an entry in the cloud_[engine]_[object]_workflows that has the 'global' attribute set to true
        def options
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            params[:workflow_id] = params[:id]
            set_workflow
            return respond_with_not_found unless @workflow

            respond_with_successful(model.options(current_user, @query, @workflow))
        end

private

        # @return [void]
        # @description Sets the variable @workflow. The variable contains the *cloud_object* *workflow* 
        #     to be handled by the controller action that called this method
        # @example
        #     #suppose params[:workflow_id] = 1
        #     puts @workflow # will display nil
        #     set_workflow
        #     puts @workflow # will display an instance of CloudHelp::Workflow
        def set_workflow
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            workflow_model = dynamic_info[:workflow_model]
            full_module_name = dynamic_info[:full_module_name]

            @workflow = workflow_model.find_by(
                id: params[:workflow_id],
                "#{full_module_name.underscore}_accounts_id".to_sym => current_user.account.id
            )
        end

        # @return [void]
        # @description Sets the variable @workflow_assigned, along the variable @workflow.
        #     The variable contains the *workflow_check* to be handled by the controller action that called this method
        # @example
        #     # suppose params[:workflow_id] = 2
        #     # suppose params[:id] = 4
        #     puts @workflow # will display nil
        #     puts @workflow_check # will display nil
        #     set_workflow_check
        #     puts @workflow # will display an instance of CloudHelp::Workflow
        #     puts @workflow_check # will display an instance of CloudHelp::Workflow::Check
        def set_workflow_check
            set_workflow
            @workflow_check = @workflow.checks.find_by(id: params[:id])
        end

        # @return [Parameters] Allowed parameters for the workflow
        # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
        #     If there are extra allowed params, they must be implemented on the subclass
        # @example
        #     # supose params contains {
        #     #    workflow_check: {
        #     #       workflow_for: 'projects'
        #     #       id: 10
        #     #    }
        #     #}
        #     filtered_params = check_params
        #     puts filtered_params
        #     # will remove the unpermitted params and only print {
        #     #       workflow_for: 'projects'
        #     #    }
        def check_params
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            params.require(:workflow_check).permit(
                :name,
                :active,
                :initial_status_id,
                :user_type,
                :final_status_id,
                :roles_id,
                :users_id
            )
        end

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Workflow::ChecksController < Shared::Workflow::ChecksController
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        #     puts info[:model].new # will return an instance of CloudHelp::Workflow::Check
        #     puts info[:workflow_model] # will return an instance of CloudHelp::Workflow
        def self.dynamic_info
            module_info = lesli_classname().split("::")
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                full_module_name: module_info[0],
                model: "#{module_info[0]}::Workflow::Check".constantize,
                workflow_model: "#{module_info[0]}::Workflow".constantize
            }
        end
    end
end
