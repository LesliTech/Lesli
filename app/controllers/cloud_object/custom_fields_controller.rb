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
@description Base controller for *subscriber* core entity

=end

module CloudObject

    class CustomFieldsController < ApplicationLesliController
        before_action :set_cloud_object_custom_field, only: [:update, :destroy]

        # @return [Json] Json that contains a list of all subscribers related to a *cloud_object*
        # @description Retrieves and returns all subscribers associated to a *cloud_object*. The id of the 
        #     *cloud_object* is within the *params* attribute
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let ticket_id = 1;
        #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/subscribers`);
        def index
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            dynamic_model = dynamic_info[:model]
            cloud_object_model = dynamic_info[:cloud_object_model]

            cloud_object_id = params["#{object_name}_id".to_sym]
            #events = dynamic_model.subscription_events(
            #    cloud_object_model.find(cloud_object_id),
            #    current_user
            #)
            responseWithSuccessful(cloud_object_id)
        end

        # @controller_action_param :event [String] A string that represent a valid event present in the *Subscriber* model
        # @controller_action_param :notification_type [String] A string that represents a valid notification_type
        #     present in the *Subscriber* model
        # @return [Json] Json that contains wheter the creation of the subscriber was successful or not. 
        #     If it is not successful, it returs an error message
        # @description Creates a new subscriber associated to a *cloud_object* using *current_user* as the subscriber. 
        #     The id of the *cloud_object* is within the *params* attribute
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let ticket_id = 1;
        #     let data = {
        #         subscriber: {
        #             notification_type: "web",
        #             event: "ticket_closed"
        #         }
        #     };
        #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/subscribers`, data);
        def create
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            
            cloud_object_custom_field = dynamic_info[:model].new(
                cloud_object_custom_field_params.merge(
                    user: current_user,
                    "cloud_#{module_name}_#{object_name}s_id".to_sym => params["#{object_name}_id".to_sym]
                )
            )
            if cloud_object_custom_field.save
                responseWithSuccessful(cloud_object_custom_field)
            else
                responseWithError(cloud_object_custom_field.errors.full_messages)
            end
        end

        # @controller_action_param :event [String] A string that represent a valid event present in the *Subscriber* model
        # @controller_action_param :notification_type [String] A string that represents a valid notification_type
        # @return [Json] Json that contains wheter the update of the subscriber was successful or not. 
        #     If it is not successful, it returs an error message
        # @description Updates the subscriber based on the id of the *cloud_object* and its own id.
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let ticket_id = 1;
        #     let subscriber_id = 22;
        #     data = {
        #         subscriber: {
        #             notification_type: "email"
        #         }
        #     };
        #     this.http.patch(`127.0.0.1/help/tickets/${ticket_id}/subscribers/${subscriber_id}`, data);
        def update
            if @cloud_object_custom_field.update(cloud_object_custom_field_params)
                responseWithSuccessful
            else
                responseWithError(@cloud_object_custom_field.errors.full_messages)
            end
        end

        # @return [Json] A response that contains wheter the subscriber was deleted or not.
        #     If it is not successful, it returns an error message
        # @description Deletes a subscriber from the database based on the id of the *cloud_object* and its own id.
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let ticket_id = 1;
        #     let subscriber_id = 22;
        #     this.http.delete(`127.0.0.1/help/tickets/${ticket_id}/subscribers/${subscriber_id}`);
        def destroy
            if @cloud_object_custom_field.destroy
                responseWithSuccessful
            else
                responseWithError(@cloud_object_custom_field.errors.full_messages)
            end
        end

        private

        # @return [void]
        # @description Sets the variable @cloud_object_subscriber. The variable contains the subscription 
        #     to be updated based on the id of the *cloud_object* and the id of the *subscriber*
        # @example
        #     suppose params[:ticket_id] = 1
        #     suppose params[:id] = 44
        #     puts @cloud_object_subscriber # will display nil
        #     set_cloud_object_subscriber
        #     puts @cloud_object_subscriber # will display an instance of CloudHelp:Ticket::Subscriber
        def set_cloud_object_custom_field
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            @cloud_object_custom_field = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_custom_fields.id = #{params[:id]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_#{object_name}s_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

        # @return [Parameters] Allowed parameters for the subscriber
        # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
        #     Allowed params are _:event_, _:notification_type_.
        # @example
        #       supose params contains {
        #          "subscriber": {
        #              "id": 5,
        #              "event": "ticket_created",
        #              "notification_type": "email",
        #              "random_param": 5
        #          }
        #      }
        #     subscriber_params = cloud_object_subscriber_params
        #     puts subscriber_params
        #       will remove the _id_ and _random_param_ fields and only print {
        #          "subscriber": {
        #              "event": "ticket_created",
        #              "notification_type": "email"
        #          }
        #      }
        def cloud_object_custom_field_params
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            params.require(:custom_field).permit(
                :field_name,
            )
        end

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Ticket::SubscribersController < CloudObject::SubscribersController
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        #     puts info[:object_name] # will print 'ticket'
        #     info[:model].new # will return an instance of CloudHelp::Ticket::Subscriber
        #     info[:cloud_object_model].new # will return an instance of CloudHelp::Ticket
        def self.dynamic_info
            module_info = lesli_classname().split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::CustomField".constantize,
                cloud_object_model: "#{module_info[0]}::#{module_info[1]}".constantize
            }
        end
        
    end
end
