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
module Interfaces::Controllers::Activities

    # @return [Json] Json that contains a list of all activities related to a *cloud_object*
    # @description Retrieves and returns all activities associated to a *cloud_object*. The id of the 
    #     *cloud_object* is within the *params* attribute
    # @example
    #     # Executing this controller's activity from javascript's frontend
    #     let ticket_id = 1;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/activities`);
    def index
        activity_model = activity_model() # If there is a custom activity model, it must be returned in this method
        cloud_object_model = activity_model.cloud_object_model
        translations_module = activity_model.name.split("::")[0].gsub("Cloud", "").underscore
        
        @activities = activity_model.where(
            "#{cloud_object_model.table_name}_id".to_sym => params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]
        ).order(id: :desc).map do |activity|
            # We translate the category, first, we search in the core
            category = I18n.t("core.shared.activities_enum_category_#{activity[:category]}", default: nil)
            # Then we search in the engine
            category = I18n.t("#{translations_module}.shared.activities_enum_category_#{activity[:category]}", default: nil) unless category
            #Then we default to the real field
            category = activity[:category] unless category

            activity_attributes = activity.attributes
            activity_attributes["category"] = category
            activity_attributes["created_at_raw"] = activity[:created_at]
            activity_attributes["created_at"] = LC::Date.to_string_datetime(activity[:created_at])
            activity_attributes["updated_at"] = LC::Date.to_string_datetime(activity[:updated_at])

            user = activity.user_creator
            activity_attributes[:user_name] = user.full_name if user

            activity_attributes
        end
        
        if block_given?
            yield(@activities)
        else
            respond_with_successful(@activities)
        end
    end

    # @return [JSON] The json information about the selected activity
    # @description Retrieves and returns the information about the activity. The id of the 
    #     *cloud_object* and the id of the *activity* are within the *params* attribute. If a block
    #     is provided, the execution will be yielded sending the activity as first parameter
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let activity_id = 5;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/activities/${activity_id}`);
    def show
        set_activity
        return respond_with_not_found unless @activity

        if block_given?
            yield(@activity)
        else
            return respond_with_successful(@activity)
        end
    end
    
    # @controller_action_param :description [String] The description of the activity
    # @controller_action_param :field [String] The field that was changed (if any)
    # @controller_action_param :value_from [String] The initial field value of the activity (if any)
    # @controller_action_param :value_to [String] The final field value of the activity (if any)
    # @controller_action_param :category [String] An enum value, that indicates the type of activity recorded
    # @return [Json] Json that contains wheter the creation of the activity was successful or not. 
    #     If it is not successful, it returs an error message
    # @description Creates a new activity associated to a *cloud_object*. The id of the 
    #     *cloud_object* is within the *params* attribute
    # @example
    #     # Executing this controller's activity from javascript's frontend
    #     let ticket_id = 1;
    #     let data = {
    #         ticket_activity: {
    #             description: "Created",
    #             category: "action_create"
    #         }
    #     };
    #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/activities`, data);
    def create
        activity_model = activity_model() # If there is a custom activity model, it must be returned in this method
        cloud_object_model = activity_model.cloud_object_model

        set_cloud_object
        new_activity_params = activity_params.merge(
            user_creator: current_user,
            cloud_object: @cloud_object
        )

        activity = activity_model.new(new_activity_params)
        if activity.save
            if block_given?
                yield(cloud_object, activity)
            else
                # Returning the 200 HTTP response
                respond_with_successful(activity)
            end
        else
            respond_with_error(activity.errors.full_messages)
        end
    end

    protected

    # @return [void]
    # @descriptions Sets the variable @cloud_object based on the paremeters send in the URL. If no,
    #     cloud_object is found or it is not within the current_user's account, nil is used instead
    # @example
    #     # Imagine you are inside CloudFocus::Task::ActivitiesController
    #     puts @cloud_object # will display nil
    #     set_cloud_object
    #     puts @cloud_object # Will display an instance of CloudFocus::Task
    def set_cloud_object
        activity_model = activity_model() # If there is a custom activity model, it must be returned in this method
        cloud_object_model = activity_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @cloud_object = cloud_object_model.find_by(
            id: params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym],
            "#{account_model.table_name}_id".to_sym => current_user.account.id
        )
    end

    # @return [void]
    # @description Sets the variable @activity. The variable contains the activity 
    #     to be updated based on the id of the *cloud_object* and the id of the *activity*
    # @example
    #     #suppose params[:ticket_id] = 1
    #     #suppose params[:id] = 44
    #     puts @activity # will display nil
    #     set_activity
    #     puts @activity # will display an instance of CloudHelp:Ticket::Action
    def set_activity
        activity_model = activity_model() # If there is a custom activity model, it must be returned in this method
        cloud_object_model = activity_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @activity = activity_model.joins(:cloud_object).where(
            "#{cloud_object_model.table_name}.id = #{params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]}",
            "#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}"
        ).find_by(
            id: params[:id]
        )
    end

    # @return [Parameters] Allowed parameters for the activity
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are _:description_, _:field_name_, _:value_from_, _:value_toe_, _:category_
    # @example
    #     # supose params contains {
    #     #    "ticket_activity": {
    #     #        "id": 5,
    #     #        "description": "User requested this ticket",
    #     #        "tags": "Important",
    #     #        "info": "Example"
    #     #    }
    #     #}
    #     activity_params = activity_params
    #     puts activity_params
    #     # will remove all unpermitted fields and only print {
    #     #    "ticket_activity": {
    #     #        "description": "User requested this ticket"
    #     #    }
    #     #}
    def activity_params
        dynamic_info = self.class.dynamic_info
        module_name = dynamic_info[:module_name]
        object_name = dynamic_info[:object_name] 

        params.require(
            "#{object_name}_activity".to_sym
        ).permit(
            :description,
            :field_name,
            :value_from,
            :value_to,
            :category,
        )
    end

    # @return [CloudObject::Activity] The activity model that the controller will handle
    # @descriptions Constantizes and returns the activity model associated to this controller. This method
    #      can be overrided by the implementation in the child controller
    # @example
    #     # Suppose you are inside CloudHelp::Ticket::ActivitiesController
    #     puts activity_model().new
    #     # This will display a new instance of CloudHelp::Ticket::Activity
    def activity_model
        self.class.name.gsub("Controller","").singularize.constantize
    end
end
