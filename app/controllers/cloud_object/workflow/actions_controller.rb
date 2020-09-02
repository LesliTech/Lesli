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
@description Base controller for *workflow* *actions* core entity. A workflow actions is executed
    when a cloud_object changes status
=end
    class Workflow::ActionsController < ApplicationLesliController
        before_action :set_workflow, only: [:index, :create, :options_create_cloud_object_file]
        before_action :set_workflow_action, only: [:update, :destroy]

    
        # @return [HTML|JSON] HTML view for listing all workflow actions or a Json that contains a list 
        #     of all workflows associated to this *account*
        # @description Retrieves and returns all workflow actions associated to a *CloudModule::Account*. 
        #     The account is obtained directly from *current_user*. The HTTP request has to specify
        #     wheter the HTML or the JSON text should be rendered
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let workflow_id = 4;
        #     this.http.get(`127.0.0.1/help/workflows/${workflow_id}/actions`);
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    return respond_with_not_found unless @workflow

                    dynamic_info = self.class.dynamic_info
                    model = dynamic_info[:model]
                    
                    respond_with_successful(model.list(@workflow))
                end
            end
        end

        # @return [HTML|JSON] HTML view for the requested workflow action or a Json that contains a the information
        #     about the action
        # @description Retrieves and returns a specific workflow action associated to a *CloudModule::Account*. 
        #     The account is obtained directly from *current_user*. The HTTP request has to specify
        #     wheter the HTML or the JSON text should be rendered
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let workflow_id = 4;
        #     let workflow_action_id = 55;
        #     this.http.get(`127.0.0.1/help/workflows/${workflow_id}/actions/${workflow_action_id}`);
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    set_workflow_action
                    return respond_with_not_found unless @workflow_action
                    
                    respond_with_successful(@workflow_action.show)
                end
            end
        end

        # @controller_action_param :name [String] The name of the workflow action
        # @controller_action_param :initial_status_id [Integer] The id of the initial status
        # @controller_action_param :final_status_id [Integer] The id of the final status
        # @controller_action_param :action_type [String] The type of action. Check the enum in the model for more information
        # @controller_action_param :execute_immediately [Boolean] Wheter this action should be executed right away or queued in a job
        # @controller_action_param :template_path [String] The path to a template
        # @controller_action_param :input_data [JSON] key/value pairs that are used as data for the workflow action
        # @controller_action_param :input_data [JSON] key/value pairs of information already stored in the system that are used as data for the workflow action
        # @controller_action_param :concerning_users [JSON] Object of concerning users for this cloud action
        # @controller_action_param :configuration [JSON] Final pairs key/value that indication extra configuration for the action
        # @return [Json] Json that contains wheter the creation of the workflow action was successful or not. 
        #     If it is not successful, it returns an error message
        # @description Creates a new workflow action associated to the *current_user*'s *account*
        # @example
        # # Executing this controller's action from javascript's frontend
        #     let workflow_id = 5;
        #     let data = {
        #         workflow_action: {
        #             name: "Test Action",
        #             action_type: "create_focus_task"
        #         }
        #     };
        #     this.http.post('127.0.0.1/help/workflows/${workflow_id}/actions', data);
        def create
            return respond_with_not_found unless @workflow

            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            action = model.new(workflow_action_params)
            action.workflow = @workflow

            if action.save
                respond_with_successful(action)
            else
                respond_with_error(action.errors.full_messages.to_sentence)
            end
        end

        # @return [Json] Json that contains wheter the update of the workflow action was successful or not. 
        #     If it is not successful, it returs an error message
        # @controller_action_param :name [String] The name of the workflow action
        # @controller_action_param :initial_status_id [Integer] The id of the initial status
        # @controller_action_param :final_status_id [Integer] The id of the final status
        # @controller_action_param :action_type [String] The type of action. Check the enum in the model for more information
        # @controller_action_param :execute_immediately [Boolean] Wheter this action should be executed right away or queued in a job
        # @controller_action_param :template_path [String] The path to a template
        # @controller_action_param :input_data [JSON] key/value pairs that are used as data for the workflow action
        # @controller_action_param :input_data [JSON] key/value pairs of information already stored in the system that are used as data for the workflow action
        # @controller_action_param :concerning_users [JSON] Object of concerning users for this cloud action
        # @controller_action_param :configuration [JSON] Final pairs key/value that indication extra configuration for the action
        # @description Updates the workflow action based on the id of the *cloud_object* and its own id.
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let workflow_id = 1;
        #     let workflow action_id = 22;
        #     data = {
        #         workflow action: {
        #             execute_immediately: true
        #         }
        #     };
        #     this.http.patch(`127.0.0.1/house/workflows/${ticket_id}/actions/${workflow action_id}`, data);
        def update
            return respond_with_not_found unless @workflow_action

            if @workflow_action.update(workflow_action_params)
                respond_with_successful
            else
                respond_with_error(@workflow_action.errors.full_messages.to_sentence)
            end
        end

        # @return [Json] Json that contains wheter the workflow was successfully deleted or not. 
        # If it it not successful, it returns an error message
        # @description Deletes an existing *workflow* associated to the *current_user*'s *account*.
        # Since the workflow has details, these are also deleted. However, if there
        # is an existing *cloud_object* associated to the *workflow*, it cannot be deleted
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let workflow_id = 4;
        #     let action_id = 9;
        #     this.http.delete(`127.0.0.1/help/workflows/${workflow_id}/actions/${action_id}`);
        def destroy
            return respond_with_not_found unless @workflow_action

            if @workflow_action.destroy
                respond_with_successful
            else
                respond_with_error(@workflow_action.errors.full_messages.to_sentence)
            end
        end

        # @return [JSON] A list of global actions of the workflow
        # @description Obtains a list of all the global actions of this workflow. A global action
        #     is an entry in the cloud_[engine]_[object]_workflows that has the 'global' attribute set to true
        def options
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            params[:workflow_id] = params[:id]
            set_workflow

            return respond_with_not_found unless @workflow

            respond_with_successful(model.options(current_user, @workflow))
        end

        def options_create_cloud_object_file
            return respond_with_not_found unless @workflow
            
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]
            respond_with_successful(model.options_create_cloud_object_file(current_user, @query, @workflow))
        end

        private

        # @return [void]
        # @description Sets the variable @workflow. The variable contains the *cloud_object* *workflow* 
        #     to be handled by the controller action that called this method
        # @example
        #     #suppose params[:workflow_id] = 1
        #     puts @workflow # will display nil
        #     set_workflow
        #     puts @workflow # will display an instance of CloudModule::Workflow
        def set_workflow
            dynamic_info = self.class.dynamic_info
            workflow_model = dynamic_info[:workflow_model]
            module_name = dynamic_info[:module_name]

            @workflow = workflow_model.find_by(
                id: params[:workflow_id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

        # @return [void]
        # @description Sets the variable @workflow_assigned, along the variable @workflow.
        #     The variable contains the *workflow_action* to be handled by the controller action that called this method
        # @example
        #     # suppose params[:workflow_id] = 2
        #     # suppose params[:id] = 4
        #     puts @workflow # will display nil
        #     puts @workflow_action # will display nil
        #     set_workflow_action
        #     puts @workflow # will display an instance of CloudHelp::Workflow
        #     puts @workflow_action # will display an instance of CloudHelp::Workflow::Action
        def set_workflow_action
            set_workflow
            return unless @workflow

            @workflow_action = @workflow.actions.find_by(id: params[:id])
        end

        # @return [Parameters] Allowed parameters for the workflow action
        # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
        #     Allowed params are _:content_, _:cloud_object_workflow actions_id_.
        # @example
        #     # supose params contains {
        #     #    "workflow_action": {
        #     #        "id": 5,
        #     #        "name": "This is a new action",
        #     #        "cloud_help_workflows_id": 4,
        #     #        "random_field": true
        #     #    }
        #     #}
        #     workflow action_params = workflow_action_params
        #     puts workflow action_params
        #     # will remove the _id_ field and only print {
        #     #    "workflow_action": {
        #     #        "name": "This is a new action",
        #     #        "cloud_help_workflows_id": 4
        #     #    }
        #     #}
        def workflow_action_params
            module_name = self.class.dynamic_info[:module_name]

            json_fields = [:system_data, :input_data, :concerning_users, :configuration]
            if params[:workflow_action]
                json_fields.each do |json_field|
                    params[:workflow_action][json_field] = params[:workflow_action][json_field].to_json if params[:workflow_action][json_field]
                end
            end

            permitted_params = params.require("workflow_action".to_sym).permit(
                :name,
                :initial_status_id,
                :final_status_id,
                :action_type,
                :execute_immediately,
                :template_path,
                :input_data,
                :system_data,
                :concerning_users,
                :configuration,
                "cloud_#{module_name}_workflows_id".to_sym
            )

            json_fields.each do |json_field|
                permitted_params[json_field] = JSON.parse(permitted_params[json_field]) if permitted_params[json_field]
            end

            permitted_params
        end

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Workflow::ActionsController < CloudObject::Workflow::ActionsController
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        #     puts info[:model].new # will return an instance of CloudHelp::Workflow::Action
        #     puts info[:workflow_model] # will return an instance of CloudHelp::Workflow
        def self.dynamic_info
            module_info = lesli_classname().split("::")
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                model: "#{module_info[0]}::Workflow::Action".constantize,
                workflow_model: "#{module_info[0]}::Workflow".constantize
            }
        end

    end
end
