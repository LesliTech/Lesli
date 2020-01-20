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
@description Base controller for *state* core entity. A state will be used to name transitions
    in  a *workflow*
=end
    class StatesController < ApplicationLesliController
        before_action :set_state, only: [:update, :destroy]

=begin
@return [HTML|JSON] HTML view for listing all states or a Json that contains a list 
    of all states associated to this *account*
@description Retrieves and returns all states associated to a *CloudHelp::Account*. 
    The account is obtained directly from *current_user*. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    this.http.get(`127.0.0.1/help/ticket_states`);
=end
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    model = dynamic_info[:model]
                    module_name = dynamic_info[:module_name]
                    
                    states = model.where(
                        "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
                    ).select(
                        :id,            :name,
                        :initial,       :final,
                        :created_at,    :updated_at
                    ).order(
                        initial: :desc,
                        final: :asc,
                        name: :asc
                    )
                    responseWithSuccessful(states) 
                end
            end
        end

=begin
@return [HTML|Json] HTML view showing the requested state or a Json that contains the
    information of the state. If there is an error, an explanation message is sent
@description Retrieves and returns the requested ticket state. The id of the 
    state is within the *params* attribute of the controller. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    let ticket_state_id = 1;
    this.http.get(`127.0.0.1/help/ticket_states/${ticket_state_id}`);
=end
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    set_state
                    return responseWithNotFound unless @state

                    responseWithSuccessful(@state)
                end
            end
        end

=begin
@return [HTML] HTML view for creating a new state
@description returns an HTML view with a form so users can create a new state
@example
    # Executing this controller's action from javascript's frontend
    this.url.go('/help/ticket_states/new')
=end
        def new
        end

=begin
@return [HTML] HTML view for editing the state
@description returns an HTML view with a form so users edit an existing state
@example
    # Executing this controller's action from javascript's frontend
    let ticket_state_id = 3;
    this.url.go(`/help/ticket_states/${ticket_states_id}/edit`)
=end
        def edit
        end

=begin
@controller_action_param :name [String] The name of the new state
@return [Json] Json that contains wheter the creation of the state was successful or not. 
    If it is not successful, it returns an error message
@description Creates a new state associated to the *current_user*'s *account*
@example
    # Executing this controller's action from javascript's frontend
    let data = {
        ticket_state: {
            name: "In Progress"
        }
    };
    this.http.post('127.0.0.1/help/ticket_states', data);
=end
        def create
            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]

            state = model.new(state_params.merge(
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            ))

            if state.save
                responseWithSuccessful(state)
            else
                responseWithError(state.errors.full_messages.to_sentence)
            end
        end

=begin
@controller_action_param :name [String] The name of the state
@return [Json] Json that contains wheter the ticket state was successfully updated or not. 
    If it it not successful, it returns an error message
@description Updates an existing state associated to the *current_user*'s *account*.
@example
    # Executing this controller's action from javascript's frontend
    let ticket_state_id = 4;
    let data = {
        ticket_state: {
            name: "Verifying Quality"
        }
    };
    this.http.put(`127.0.0.1/help/ticket_states/${ticket_state_id}`, data);
=end
        def update
            return responseWithNotFound unless @state

            if @state.update(state_params)
                responseWithSuccessful(@state)
            else
                responseWithError(@state.errors.full_messages.to_sentence)
            end
        end

=begin
@return [Json] Json that contains wheter the ticket state was successfully deleted or not. 
    If it it not successful, it returns an error message
@description Deletes an existing *state* associated to the *current_user*'s *account*.
    If there is an existing *workflow* associated to the *state*, it cannot be deleted
@example
    # Executing this controller's action from javascript's frontend
    let ticket_state_id = 4;
    this.http.delete(`127.0.0.1/help/ticket_states/${ticket_state_id}`);
=end
        def destroy
            return responseWithNotFound unless @state
            
            if @state.destroy
                responseWithSuccessful
            else
                responseWithError(@state.errors.full_messages.to_sentence)
            end
        end

        private

=begin
@return [void]
@description Sets the variable @state. The variable contains the *state* 
    to be handled by the controller action that called this method
@example
    #suppose params[:id] = 1 and controller is CloudHelp::TicketStatesController
    puts @state # will display nil
    set_state
    puts @state # will display an instance of CloudHelp:TicketState
=end
        def set_state
            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]

            @state = model.find_by(
                id: params[:id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

=begin
@return [Parameters] Allowed parameters for the state
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    Allowed params are :name
@example
    # supose params contains {
    #    "ticket_state": {
    #        "id": 5,
    #        "name": "Reviewing Changes"
    #    }
    #}
    filtered_params = state_params
    puts filtered_params
    # will remove the id and only print {
    #    "name": "Reviewing Changes"
    #}
=end
        def state_params
            object_name = dynamic_info[:object_name]
            params.fetch(object_name.to_sym, {}).permit(:name)
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::TicketStatesController < CloudObject::StatesController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:object_name] # will print 'ticket_state'
    info[:model].new # will return an instance of CloudHelp::TicketState
=end
        def dynamic_info
            module_info = self.class.name.split("::")
            cloud_object_name = module_info[1].sub("StatesController", "")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: "#{cloud_object_name.downcase}_state",
                model: "#{module_info[0]}::#{cloud_object_name}State".constantize
            }
        end
    end
end
