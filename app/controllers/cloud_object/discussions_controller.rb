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
    class DiscussionsController < ApplicationLesliController
        before_action :set_cloud_object_discussion, only: [:update, :destroy]
        before_action :check_has_authorization, only: [:update, :destroy]


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
                dynamic_info[:model].list(
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
            discussion_model = dynamic_info[:discussion_model]
            plural_object_name = object_name.pluralize

            cloud_object_dicussion = dynamic_info[:model].new(
                cloud_object_discussion_params.merge({
                    users_id: current_user.id,
                    "cloud_#{module_name}_#{plural_object_name}_id".to_sym => params["#{object_name}_id".to_sym]
                })
            )

            if cloud_object_dicussion.save
                responseWithSuccessful(cloud_object_dicussion.show)

                cloud_object = cloud_object_dicussion.cloud_object
                message = I18n.t(
                    "cloud_#{module_name}.controllers.#{object_name}.discussions.notifications.created",
                    "#{object_name}_id".to_sym => cloud_object.id
                )
                #discussion_model.notify_discussions(cloud_object, message, :comment_created) unless discussion_model.blank?
            else
                responseWithError(cloud_object_dicussion.errors.full_messages.to_sentence)
            end
        end

=begin
@controller_action_param :content [String] The commented message
@controller_action_param :cloud_object_discussions_id [Integer] The id of a discussions that this message responds to
@return [Json] Json that contains wheter the update of the discussion was successful or not. 
    If it is not successful, it returs an error message
@description Updates the discussion based on the id of the *cloud_object* and its own id.
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let discussion_id = 22;
    data = {
        discussion: {
            content: "This is a comment"
        }
    };
    this.http.patch(`127.0.0.1/help/tickets/${ticket_id}/discussions/${discussion_id}`, data);
=end
        def update
            if @cloud_object_discussion.update(cloud_object_discussion_params)
                responseWithSuccessful
            else
                responseWithError(@cloud_object_discussion.errors.full_messages.to_sentence)
            end
        end

=begin
@return [Json] A response that contains wheter the discussion was deleted or not.
If it is not successful, it returns an error message
@description Deletes a discussion from the database based on the id of the *cloud_object* and its own id.
@example
# Executing this controller's action from javascript's frontend
let ticket_id = 1;
let discussion_id = 22;
this.http.delete(`127.0.0.1/help/tickets/${ticket_id}/discussions/${discussion_id}`);
=end
        def destroy
            if @cloud_object_discussion.destroy
                responseWithSuccessful
            else
                responseWithError(@cloud_object_discussion.errors.full_messages.to_sentence)
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
@return [void]
@description Sets the variable @cloud_object_discussion. The variable contains the discussion 
    to be updated based on the id of the *cloud_object* and the id of the *discussion*
@example
    #suppose params[:ticket_id] = 1
    #suppose params[:id] = 44
    puts @cloud_object_discussion # will display nil
    set_cloud_object_discussion
    puts @cloud_object_discussion # will display an instance of CloudHelp:Ticket::Discussion
=end
        def set_cloud_object_discussion
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize

            @cloud_object_discussion = dynamic_info[:model].joins(:cloud_object).where("
                cloud_#{module_name}_#{object_name}_discussions.id = #{params[:id]} and
                cloud_#{module_name}_#{plural_object_name}.id = #{params["#{object_name}_id".to_sym]} and
                cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_accounts_id = #{current_user.account.id}
            ").first
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
    info[:discussion_model].new # will return an instance of CloudHelp::Ticket::Subscriber
=end
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Discussion".constantize,
                discussion_model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end


        def check_has_authorization
            unless current_user.is_role?("owner", "admin")
                return responseWithUnauthorized if current_user != @cloud_object_discussion.user
            end
        end

    end
end
