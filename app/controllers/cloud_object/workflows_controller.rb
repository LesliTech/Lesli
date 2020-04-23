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
@description Base controller for *workflow* core entity. A workflow will be a list of posible transitions
    throught the *cloud_object* lifespan
=end
    class WorkflowsController < ApplicationLesliController
        before_action :set_workflow, only: [:update, :destroy]


=begin
@return [HTML|JSON] HTML view for listing all workflows or a Json that contains a list 
    of all workflows associated to this *account*
@description Retrieves and returns all workflows associated to a *CloudHelp::Account*. 
    The account is obtained directly from *current_user*. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    this.http.get(`127.0.0.1/help/workflows`);
=end
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    dynamic_info = self.class.dynamic_info
                    model = dynamic_info[:model]

                    workflows = model.list(current_user, @query)
                    responseWithSuccessful(workflows)
                end
            end
        end

=begin
@return [HTML|Json] HTML view showing the requested workflow or a Json that contains the
    information of the workflow. If there is an error, an explanation message is sent
@description Retrieves and returns the requested workflow. The id of the 
    workflow is within the *params* attribute of the controller. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    let workflow_id = 1;
    this.http.get(`127.0.0.1/help/workflows/${workflow_id}`);
=end
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    dynamic_info = self.class.dynamic_info
                    module_name = dynamic_info[:module_name]

                    set_workflow
                    if @workflow
                        responseWithSuccessful(@workflow.detailed_info)
                    else
                        responseWithError('Workflow not found')
                    end
                end
            end
        end

=begin
@return [HTML] HTML view for creating a new workflow
@description returns an HTML view with a form so users can create a new workflow
@example
    # Executing this controller's action from javascript's frontend
    this.url.go('/help/workflows/new')
=end
        def new
        end
=begin
@return [HTML] HTML view for editing the workflow
@description returns an HTML view with a form so users edit an existing workflow
@example
    # Executing this controller's action from javascript's frontend
    let workflow_id = 3;
    this.url.go(`/help/workflows/${workflow_id}/edit`)
=end
        def edit
        end

=begin
@controller_action_param :name [String] The name of the new workflow
@controller_action_param :default [Boolean] A flag that marks this workflow as default or not
@controller_action_param :statuses_attributes [Array] Array of hashes, containing the information of the new attributes
@controller_action_param :statuses_attributes.next_states [String] Transitions to the next state. The format is 
    "[workflow_state_id]|[workflow_state_id]|..."
@controller_action_param :statuses_attributes.cloud_[module_name]_[cloud_object_name]_workflow_states_id [Integer]
    The id of the state associated to this detail
@return [Json] Json that contains wheter the creation of the workflow was successful or not. 
    If it is not successful, it returns an error message
@description Creates a new workflow associated to the *current_user*'s *account*
@example
# Executing this controller's action from javascript's frontend
    let data = {
        workflow: {
            name: "Important",
            default: true,
            statuses_attributes: [
                {
                    cloud_help_workflow_states_id: 4,
                    next_states: "6"
                },{
                    cloud_help_workflow_states_id: 6,
                    next_states: null
                }
            ]
        }
    };
    this.http.post('127.0.0.1/help/workflows', data);
=end
        def create
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]

            workflow = model.new(workflow_params)
            workflow["cloud_#{module_name}_accounts_id".to_sym] = current_user.account.id

            if workflow.save
                responseWithSuccessful(workflow)
            else
                responseWithError(workflow.errors.full_messages.to_sentence)
            end
        end

=begin
@controller_action_param :name [String] The name of the new workflow
@controller_action_param :default [Boolean] A flag that marks this workflow as default or not
@controller_action_param :detail_attributes [Array] Arary of hashes that represent the attributes
    of the workflow details
@controller_action_param :detail_attributes.id [Integer] The id of the detail
@controller_action_param :detail_attributes.next_states [String] A string of numbers, separated by '|'.
    Each number represents the id of a *CloudObject::WorkflowState* and creates a valid transition. 
    A valid transition is a transition from one detail that has a state in its *next_states* attribute 
    to another detail, that has that state in its *workflow_state_id* attribute
@controller_action_param :detail_attributes._workflow_state_id [Integer]
    The id of the state associated to this workflow detail
@return [Json] Json that contains wheter the workflow was successfully updated or not. 
    If it it not successful, it returns an error message
@description Updates an existing workflow associated to the *current_user*'s *account*.
@example
# Executing this controller's action from javascript's frontend
let workflow_id = 4;
let data = {
    workflow: {
        name: "Sales Workflow",
        statuses_attributes: [
            {
                id: 1,
                next_states: '56|57',
                workflow_states_id: 55
            }, {
                id: 4,
                next_states: null,
                workflow_states_id: 56
            }, {
                id: 5,
                next_states: null,
                workflow_states_id: 57
            }
        ]
    }
};
this.http.put(`127.0.0.1/help/workflows/${workflow_id}`, data);
=end
        def update
            return responseWithNotFound unless @workflow

            if @workflow.update(workflow_params)
                responseWithSuccessful(@workflow)
            else
                responseWithError(@workflow.errors.full_messages.to_sentence)
            end
        end

=begin
@return [Json] Json that contains wheter the workflow was successfully deleted or not. 
    If it it not successful, it returns an error message
@description Deletes an existing *workflow* associated to the *current_user*'s *account*.
    Since the workflow has details, these are also deleted. However, if there
    is an existing *cloud_object* associated to the *workflow*, it cannot be deleted
@example
    # Executing this controller's action from javascript's frontend
    let workflow_id = 4;
    this.http.delete(`127.0.0.1/help/workflows/${workflow_id}`);
=end
        def destroy
            return responseWithNotFound unless @workflow

            if @workflow.destroy
                responseWithSuccessful
            else
                responseWithError(@workflow.errors.full_messages.to_sentence)
            end
        end

=begin
@description Retrieves a list of possible transitions the the *cloud_object*, depending on the *state* they are actually in.
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 6
    this.http.get(`127.0.0.1/help/options/workflows/ticket/${ticket_id}`).then(response => {
        if( response.successful ){
            console.log(JSON.stringify(response.data))
            # This will print something similar to
            #[
            #    {"id":2,"name":"closed","workflow_detail_id":8},
            #    {"id":3,"name":"In progress","workflow_detail_id":9}
            #]
            # where "id" is the id of the wokflow state
        }
    });
=end
        def workflow_options
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            full_module_name = dynamic_info[:full_module_name]
            cloud_object_model = "#{full_module_name}::#{params[:cloud_object_name].capitalize}".constantize

            cloud_object = cloud_object_model.find_by(
                id: params[:cloud_object_id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )

            return responseWithNotFound unless cloud_object

            responseWithSuccessful(cloud_object.status.next_workflow_statuses)
        end

private

=begin
@return [void]
@description Sets the variable @workflow. The variable contains the *cloud_object* *workflow* 
    to be handled by the controller action that called this method
@example
    #suppose params[:id] = 1
    puts @workflow # will display nil
    set_workflow
    puts @workflow # will display an instance of CloudHelp:TicketWorkflow
=end
        def set_workflow
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]
            module_name = dynamic_info[:module_name]

            @workflow = model.find_by(
                id: params[:id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

=begin
@return [Parameters] Allowed parameters for the workflow
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    Allowed params are, :name, :default, statuses_attributes: 
    [:id, :next_state, :cloud_[module_name]_workflow_states_id]
@example
    # supose params contains {
    #    workflow: {
    #       id: 5,
    #       name: "Workflow Name"
    #       default: false,
    #       statuses_attributes: [
    #            {
    #                id: 1,
    #                next_states: "4|5|6",
    #                name: "In use",
    #                cloud_help_states_id: 5
    #            }
    #        ]
    #    }
    #}
    filtered_params = workflow_params
    puts filtered_params
    # will remove the unpermitted params and only print {
    #       name: "Workflow Name"
    #       default: false,
    #       statuses_attributes: [
    #            {
    #                id: 1,
    #                next_states: "4|5|6",
    #                cloud_help_states_id: 5
    #            }
    #        ]
    #    }
=end
        def workflow_params
            params.require(:workflow).permit(
                :name,
                :default,
                statuses_attributes: [
                    :id,
                    :next_statuses,
                    :initial,
                    :final,
                    :name,
                    :number,
                    :_destroy
                ]
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::WorkflowsController < CloudObject::WorkflowsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:full_module_name] # will print 'CloudHelp'
    info[:model].new # will return an instance of CloudHelp::TicketWorkflow
=end
        def self.dynamic_info
            module_info = self.name.split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            module_name = "house" if module_name == "haus"
            
            {
                module_name: module_name,
                full_module_name: module_info[0],
                model: "#{module_info[0]}::Workflow".constantize
            }
        end
    end
end
