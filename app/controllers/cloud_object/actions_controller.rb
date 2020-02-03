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
@description Base controller for *action* core entity

=end
    class ActionsController < ApplicationController
        before_action :set_cloud_object_action, only: [:update]

=begin
@return [Json] Json that contains a list of all actions related to a *cloud_object*
@description Retrieves and returns all actions associated to a *cloud_object*. The id of the 
    *cloud_object* is within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    this.http.get(`127.0.0.1/help/tickets/${ticket_id}/actions`);
=end
        def index
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize
            
            cloud_object_id = params["#{object_name}_id".to_sym]
            @cloud_object_action = dynamic_info[:model].where(
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym => cloud_object_id
            ).order(id: :desc)
            responseWithSuccessful(@cloud_object_action)
        end

=begin
@controller_action_param :instructions [String] The instructions to add to the action
@return [Json] Json that contains wheter the creation of the action was successful or not. 
    If it is not successful, it returs an error message
@description Creates a new action associated to a *cloud_object*. The id of the 
    *cloud_object* is within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let data = {
        ticket_action: {
            instructions: "Benchmark server performance"
        }
    };
    this.http.post(`127.0.0.1/help/tickets/${ticket_id}/actions`, data);
=end
        def create
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            subscriber_model = dynamic_info[:subscriber_model]
            plural_object_name = object_name.pluralize

            cloud_object_action = dynamic_info[:model].new(
                cloud_object_action_params.merge({
                    "cloud_#{module_name}_#{plural_object_name}_id".to_sym => params["#{object_name}_id".to_sym]
                })
            )

            if cloud_object_action.save
                responseWithSuccessful

                cloud_object = cloud_object_action.cloud_object
                message = I18n.t(
                    "cloud_#{module_name}.controllers.#{object_name}.actions.notifications.created",
                    "#{object_name}_id".to_sym => cloud_object.id
                )
                subscriber_model.notify_subscribers(cloud_object, message, :action_created)
            else
                responseWithError(cloud_object_action.errors.full_messages.to_sentence)
            end
        end

=begin
@controller_action_param :complete [Boolean] Wheter this action is complete or not
@return [Json] Json that contains wheter the update of the action was successful or not. 
    If it is not successful, it returs an error message
@description Updates the action based on the id of the *cloud_object* and its own id.
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let action_id = 22;
    data = {
        ticket_action: {
            complete: true
        }
    };
    this.http.put(`127.0.0.1/help/tickets/${ticket_id}/actions/${action_id}`, data);
=end
        def update
            if @cloud_object_action.update(cloud_object_action_params)
                responseWithSuccessful
            else
                responseWithError(@cloud_object_action.errors.full_messages.to_sentence)
            end
        end

        private

=begin
@return [void]
@description Sets the variable @cloud_object_action. The variable contains the action 
    to be updated based on the id of the *cloud_object* and the id of the *action*
@example
    #suppose params[:ticket_id] = 1
    #suppose params[:id] = 44
    puts @cloud_object_action # will display nil
    set_cloud_object_action
    puts @cloud_object_action # will display an instance of CloudHelp:Ticket::Action
=end
        def set_cloud_object_action
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize

            @cloud_object_action = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_actions.id = #{params[:id]}",
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_#{plural_object_name}_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

=begin
@return [Parameters] Allowed parameters for the action
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    Allowed params are _:type_, _:instructions_, _:deadline_, _:complete_, _:tags_. 
    For now, only the _:instructions_ and _:complete_ params are taking into account
@example
    # supose params contains {
    #    "ticket_action": {
    #        "id": 5,
    #        "type": "information",
    #        "complete": true,
    #        "tags": "Important",
    #        "info": "Example"
    #    }
    #}
    action_params = cloud_object_action_params
    puts action_params
    # will remove _id_ and _info_ fields and only print {
    #    "ticket_action": {
    #        "type": "information",
    #        "complete": true,
    #        "tags": "Important"
    #    }
    #}
=end
        def cloud_object_action_params
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 

            params.require(
                "#{object_name}_action".to_sym
            ).permit(
                :type,
                :instructions,
                :deadline,
                :complete,
                :tags
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Ticket::ActionsController < CloudObject::ActionsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:object_name] # will print 'ticket'
    info[:model].new # will return an instance of CloudHelp::Ticket::Action
    info[:subscriber_model].new # will return an instance of CloudHelp::Ticket::Subscriber
=end
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Action".constantize,
                subscriber_model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end
    end
end
