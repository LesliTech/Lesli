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
@description Base controller for *discussion* core entity

=end
    class DiscussionsController < ApplicationController


=begin
@return [Json] Json that contains a list of all discussions related to a *cloud_object*
@description Retrieves and returns all discussions associated to a *cloud_object*. The id of the 
    *cloud_object* is within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    this.http.get(`127.0.0.1/help/tickets/${ticket_id}/discussions`);
=end
        def index
            responseWithSuccessful(
                dynamic_info[:model].detailed_info(
                    current_user.account, params["#{dynamic_info[:object_name]}_id".to_sym]
                )
            )
        end

=begin
@controller_action_param :content [String] The commented message
@controller_action_param :cloud_object_discussions_id [Integer] The id of a discussions that this message responds to
@return [Json] Json that contains wheter the creation of the discussion was successful or not. 
    If it is not successful, it returs an error message
@description Creates a new discussion associated to a *cloud_object* and notifies all users subscribed to this event. 
    The id of the *cloud_object* is within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let data = {
        ticket_discussion: {
            content: "This is a comment on a ticket!"
        }
    };
    this.http.post(`127.0.0.1/help/tickets/${ticket_id}/discussions`, data);
=end
        def create
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            subscriber_model = dynamic_info[:subscriber_model]
            plural_object_name = object_name.pluralize

            cloud_object_dicussion = dynamic_info[:model].new(
                cloud_object_discussion_params.merge({
                    users_id: current_user.id,
                    "cloud_#{module_name}_#{plural_object_name}_id".to_sym => params["#{object_name}_id".to_sym]
                })
            )

            if cloud_object_dicussion.save
                responseWithSuccessful

                cloud_object = cloud_object_dicussion.cloud_object
                message = I18n.t(
                    "cloud_#{module_name}.controllers.#{object_name}.discussions.notifications.created",
                    "#{object_name}_id".to_sym => cloud_object.id
                )
                #subscriber_model.notify_subscribers(cloud_object, message, :comment_created) unless subscriber_model.blank?
            else
                responseWithError(cloud_object_dicussion.errors.full_messages.to_sentence)
            end
        end

        private

=begin
@return [Parameters] Allowed parameters for the discussion
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    Allowed params are _:content_, _:cloud_object_discussions_id_.
@example
    # supose params contains {
    #    "ticket_discussion": {
    #        "id": 5,
    #        "content": "This is a message!",
    #        "cloud_help_ticket_discussions_id": 4
    #    }
    #}
    discussion_params = cloud_object_discussion_params
    puts discussion_params
    # will remove the _id_ field and only print {
    #    "ticket_discussion": {
    #        "content": "This is a message!",
    #        "cloud_help_ticket_discussions_id": 4
    #    }
    #}
=end
        def cloud_object_discussion_params
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 

            params.require("#{object_name}_discussion".to_sym).permit(
                :content,
                "cloud_#{module_name}_#{object_name}_discussions_id".to_sym
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Ticket::DiscussionsController < CloudObject::DiscussionsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:object_name] # will print 'ticket'
    info[:model].new # will return an instance of CloudHelp::Ticket::Discussion
    info[:subscriber_model].new # will return an instance of CloudHelp::Ticket::Subscriber
=end
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Discussion".constantize,
                subscriber_model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end

    end
end
