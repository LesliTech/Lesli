=begin

Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module Interfaces::Controllers::Subscribers

    # @return [Json] Json that contains a list of all subscribers related to a *cloud_object*
    # @description Retrieves and returns all subscribers associated to a *cloud_object*. The id of the 
    #     *cloud_object* is within the *params* attribute
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/subscribers`);
    def index
        subscriber_model = subscriber_model() # If there is a custom subscriber model, it must be returned in this method
        cloud_object_model = subscriber_model.cloud_object_model
        @cloud_object = cloud_object_model.find_by(id: params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym])
        return respond_with_not_found unless @cloud_object

        actions = subscriber_model.subscription_actions(
            @cloud_object,
            current_user
        )
        respond_with_successful(actions)
    end

    # @controller_action_param :action [String] A string that represent a valid action present in the *Subscriber* model
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
    #             action: "ticket_closed"
    #         }
    #     };
    #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/subscribers`, data);
    def create
        subscriber_model = subscriber_model() # If there is a custom subscriber model, it must be returned in this method
        cloud_object_model = subscriber_model.cloud_object_model

        set_cloud_object
        new_subscriber_params = subscriber_params.merge(
            user_creator: current_user,
            cloud_object: @cloud_object
        )
        cloud_object_subscriber = subscriber_model.new(new_subscriber_params)

        if cloud_object_subscriber.save
            respond_with_successful(cloud_object_subscriber)
        else
            respond_with_error(cloud_object_subscriber.errors.full_messages.to_sentence)
        end
    end

    # @controller_action_param :action [String] A string that represent a valid action present in the *Subscriber* model
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
        set_subscriber
        return respond_with_not_found unless @subscriber

        if @subscriber.update(subscriber_params)
            respond_with_successful
        else
            respond_with_error(@subscriber.errors.full_messages.to_sentence)
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
        set_subscriber
        return respond_with_not_found unless @subscriber
        
        if @subscriber.destroy
            respond_with_successful
        else
            respond_with_error(@subscriber.errors.full_messages.to_sentence)
        end
    end

    protected

    # @return [void]
    # @descriptions Sets the variable @cloud_object based on the paremeters send in the URL. If no,
    #     cloud_object is found or it is not within the current_user's account, nil is used instead
    # @example
    #     # Imagine you are inside CloudFocus::Task::DiscussionsController
    #     puts @cloud_object # will display nil
    #     set_cloud_object
    #     puts @cloud_object # Will display an instance of CloudFocus::Task
    def set_cloud_object
        subscriber_model = subscriber_model() # If there is a custom subscriber model, it must be returned in this method
        cloud_object_model = subscriber_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @cloud_object = cloud_object_model.find_by(
            id: params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym],
            "#{account_model.table_name}_id".to_sym => current_user.account.id
        )
    end

    # @return [void]
    # @description Sets the variable @subscriber. The variable contains the subscription 
    #     to be updated based on the id of the *cloud_object* and the id of the *subscriber*
    # @example
    #     #suppose params[:ticket_id] = 1
    #     #suppose params[:id] = 44
    #     puts @subscriber # will display nil
    #     set_subscriber
    #     puts @subscriber # will display an instance of CloudHelp:Ticket::Subscriber
    def set_subscriber
        subscriber_model = subscriber_model() # If there is a custom subscriber model, it must be returned in this method
        cloud_object_model = subscriber_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @subscriber = subscriber_model.joins(:cloud_object).where(
            "#{cloud_object_model.table_name}.id = #{params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]}",
            "#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}"
        ).find_by(
            id: params[:id]
        )
    end

    # @return [Parameters] Allowed parameters for the subscriber
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are _:action_, _:notification_type_.
    # @example
    #     # supose params contains {
    #     #    "subscriber": {
    #     #        "id": 5,
    #     #        "action": "ticket_created",
    #     #        "notification_type": "email",
    #     #        "random_param": 5
    #     #    }
    #     #}
    #     subscriber_params = subscriber_params
    #     puts subscriber_params
    #     # will remove the _id_ and _random_param_ fields and only print {
    #     #    "subscriber": {
    #     #        "action": "ticket_created",
    #     #        "notification_type": "email"
    #     #    }
    #     #}
    def subscriber_params
        subscriber_model = subscriber_model() # If there is a custom subscriber model, it must be returned in this method
        cloud_object_model = subscriber_model.cloud_object_model

        params.require(
            "#{cloud_object_model.name.demodulize.underscore}_subscriber".to_sym
        ).permit(
            :action,
            :notification_type
        )
    end

    # @return [CloudObject::Subscriber] The subscriber model that the controller will handle
    # @descriptions Constantizes and returns the subscriber model associated to this controller. This method
    #      can be overrided by the implementation in the child controller
    # @example
    #     # Suppose you are inside CloudHelp::Ticket::SubscriberController
    #     puts subscriber_model().new
    #     # This will display a new instance of CloudHelp::Ticket::Discussion
    def subscriber_model
        self.class.name.gsub("Controller","").singularize.constantize
    end
end
