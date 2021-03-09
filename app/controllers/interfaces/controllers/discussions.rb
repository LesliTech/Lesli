=begin

Copyright (c) 2020, all rights reserved.

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
module Interfaces::Controllers::Discussions

    # @return [Json] Json that contains a list of all discussions related to a *cloud_object*
    # @description Retrieves and returns all discussions associated to a *cloud_object*. The id of the 
    #     *cloud_object* is within the *params* attribute. If the child class provides a block, the function is
    #     yielded sending the discussions as parameters. The block given *must* return the HTTP response
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/discussions`);
    def index
        discussion_model = discussion_model() # If there is a custom discussion model, it must be returned in this method
        cloud_object_model = discussion_model.cloud_object_model
        
        @discussions = discussion_model.index(current_user, params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym])
        if block_given?
            yield(@discussions)
        else
            respond_with_successful(@discussions)
        end
    end

    # @return [JSON] The json information about the selected discussion
    # @description Retrieves and returns the information about the discussion. The id of the 
    #     *cloud_object* and the id of the *discussion* are within the *params* attribute. If a block
    #     is provided, the execution will be yielded sending the discussion as first parameter
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let discussion_id = 5;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/discussions/${discussion_id}`);
    def show
        set_discussion
        return respond_with_not_found unless @discussion

        if block_given?
            yield(@discussion)
        else
            return respond_with_successful(@discussion)
        end
    end

    # @controller_action_param :content [String] The commented message
    # @controller_action_param :discussions_id [Integer] The id of a discussions that this message responds to
    # @return [Json] Json that contains wheter the creation of the discussion was successful or not. 
    #     If it is not successful, it returs an error message
    # @description Creates a new discussion associated to a *cloud_object* and notifies all users subscribed to this event. 
    #     The id of the *cloud_object* is within the *params* attribute
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let data = {
    #         ticket_discussion: {
    #             content: "This is a comment on a ticket!"
    #         }
    #     };
    #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/discussions`, data);
    def create
        discussion_model = discussion_model() # If there is a custom discussion model, it must be returned in this method
        cloud_object_model = discussion_model.cloud_object_model

        set_cloud_object
        new_discussion_params = discussion_params.merge(
            user_creator: current_user,
            cloud_object: @cloud_object
        )

        discussion = discussion_model.new(new_discussion_params)
        if discussion.save
            translations_path = @cloud_object.class.name.gsub("Cloud", "").underscore.pluralize.gsub("/", ".")
            cloud_object_class_translation = I18n.t("#{translations_path}.view_title_main")

            "#{cloud_object_model}::Subscriber".constantize.notify_subscribers(
                discussion.cloud_object,
                "discussion_created",
                subject: "#{cloud_object_class_translation} (#{@cloud_object.global_identifier}): #{I18n.t("core.shared.view_title_notification_discussions_created")}",
                body: "#{discussion.user_creator.full_name} #{I18n.t("core.shared.view_text_notification_discussion_created_body")}: '#{discussion.content}'",
                url: "#{@cloud_object.id}?tab=discussions"
            )


            if block_given?
                yield(cloud_object, discussion)
            else
                # Returning the 200 HTTP response
                respond_with_successful(discussion.show(current_user))
            end
        else
            respond_with_error(discussion.errors.full_messages)
        end
    end

    # @controller_action_param :content [String] The content of the discussion
    # @controller_action_param :discussions_id [Integer] The id of a discussions that this message responds to
    # @return [Json] Json that contains wheter the update of the discussion was successful or not. 
    #     If it is not successful, it returs an error message
    # @description Updates the discussion based on the id of the *cloud_object* and its own id.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let discussion_id = 22;
    #     data = {
    #         discussion: {
    #             content: "This is the new content of the discussion"
    #         }
    #     };
    #     this.http.patch(`127.0.0.1/help/tickets/${ticket_id}/discussions/${discussion_id}`, data);
    def update
        set_discussion
        return respond_with_not_found unless @discussion
        return respond_with_unauthorized unless @discussion.is_editable_by?(current_user)

        if @discussion.update(discussion_params)
            respond_with_successful
        else
            respond_with_error(@discussion.errors.full_messages.to_sentence)
        end
    end

    # @return [Json] A response that contains wheter the discussion was deleted or not.
    #     If it is not successful, it returns an error message
    # @description Deletes a discussion from the database based on the id of the *cloud_object* and its own id.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let discussion_id = 22;
    #     this.http.delete(`127.0.0.1/help/tickets/${ticket_id}/discussions/${discussion_id}`);
    def destroy
        set_discussion
        return respond_with_not_found unless @discussion
        
        if @discussion.destroy
            respond_with_successful
        else
            respond_with_error(@discussion.errors.full_messages.to_sentence)
        end
    end

    protected

    # @return [Parameters] Allowed parameters for the discussion
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are _:content_, _:discussions_id_.
    # @example
    #     # supose params contains {
    #     #    "ticket_discussion": {
    #     #        "id": 5,
    #     #        "content": "This is a message!",
    #     #        "cloud_help_ticket_discussions_id": 4
    #     #    }
    #     #}
    #     discussion_params = discussion_params
    #     puts discussion_params
    #     # will remove the _id_ field and only print {
    #     #    "ticket_discussion": {
    #     #        "content": "This is a message!",
    #     #        "cloud_help_ticket_discussions_id": 4
    #     #    }
    #     #}
    def discussion_params
        discussion_model = discussion_model() # If there is a custom discussion model, it must be returned in this method
        cloud_object_model = discussion_model.cloud_object_model

        params.require(
            "#{cloud_object_model.name.demodulize.underscore}_discussion".to_sym
        ).permit(
            :content,
            "#{discussion_model.table_name}_id".to_sym
        )
    end

    # @return [void]
    # @descriptions Sets the variable @cloud_object based on the paremeters send in the URL. If no,
    #     cloud_object is found or it is not within the current_user's account, nil is used instead
    # @example
    #     # Imagine you are inside CloudFocus::Task::DiscussionsController
    #     puts @cloud_object # will display nil
    #     set_cloud_object
    #     puts @cloud_object # Will display an instance of CloudFocus::Task
    def set_cloud_object
        discussion_model = discussion_model() # If there is a custom discussion model, it must be returned in this method
        cloud_object_model = discussion_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @cloud_object = cloud_object_model.find_by(
            id: params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym],
            "#{account_model.table_name}_id".to_sym => current_user.account.id
        )
    end

    # @return [void]
    # @description Sets the variable @discussion. The variable contains the discussion 
    #     to be updated based on the id of the *cloud_object* and the id of the *discussion*
    # @example
    #     #suppose params[:ticket_id] = 1
    #     #suppose params[:id] = 44
    #     puts @discussion # will display nil
    #     set_discussion
    #     puts @discussion # will display an instance of CloudHelp:Ticket::Discussion
    def set_discussion
        discussion_model = discussion_model() # If there is a custom discussion model, it must be returned in this method
        cloud_object_model = discussion_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @discussion = discussion_model.joins(:cloud_object).where(
            "#{cloud_object_model.table_name}.id = #{params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]}",
            "#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}"
        ).find_by(
            id: params[:id]
        )
    end

    # @return [CloudObject::Discussion] The discussion model that the controller will handle
    # @descriptions Constantizes and returns the discussion model associated to this controller. This method
    #      can be overrided by the implementation in the child controller
    # @example
    #     # Suppose you are inside CloudHelp::Ticket::DiscussionsController
    #     puts discussion_model().new
    #     # This will display a new instance of CloudHelp::Ticket::Discussion
    def discussion_model
        self.class.name.gsub("Controller","").singularize.constantize
    end
end
