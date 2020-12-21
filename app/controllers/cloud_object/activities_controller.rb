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

module CloudObject
    class ActivitiesController < ApplicationLesliController
        before_action :set_cloud_object_activity, only: [:update]

        # @return [Json] Json that contains a list of all activities related to a *cloud_object*
        # @description Retrieves and returns all activities associated to a *cloud_object*. The id of the 
        #     *cloud_object* is within the *params* attribute
        # @example
        #     # Executing this controller's activity from javascript's frontend
        #     let ticket_id = 1;
        #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/activities`);
        def index
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize
            
            cloud_object_id = params["#{object_name}_id".to_sym]
            cloud_object_activities = dynamic_info[:model].where(
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym => cloud_object_id
            ).order(id: :desc).map do |activity|
                # We translate the category, first, we search in the core
                category = I18n.t("core.shared.activities_enum_category_#{activity[:category]}", default: nil)
                # Then we search in the engine
                category = I18n.t("#{module_name}.shared.activities_enum_category_#{activity[:category]}", default: nil) unless category
                #Then we default to the real field
                category = activity[:category] unless category

                activities_data = {
                    id: activity[:id],
                    category: category,
                    description: activity[:description],
                    field_name: activity[:field_name],
                    value_from: activity[:value_from],
                    value_to: activity[:value_to],
                    icon: activity[:icon],
                    created_at_raw: activity[:created_at],
                    created_at: LC::Date.to_string_datetime(activity[:created_at]),
                    updated_at: LC::Date.to_string_datetime(activity[:updated_at])
                }

                user = activity.user_creator
                activities_data[:user_name] = user.full_name if user

                activities_data
            end
            respond_with_successful(cloud_object_activities)
        end
        
        # @controller_action_param :instructions [String] The instructions to add to the activity
        # @return [Json] Json that contains wheter the creation of the activity was successful or not. 
        #     If it is not successful, it returs an error message
        # @description Creates a new activity associated to a *cloud_object*. The id of the 
        #     *cloud_object* is within the *params* attribute
        # @example
        #     # Executing this controller's activity from javascript's frontend
        #     let ticket_id = 1;
        #     let data = {
        #         ticket_action: {
        #             instructions: "Benchmark server performance"
        #         }
        #     };
        #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/activities`, data);
        def create
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            activity_model = dynamic_info[:activity_model]
            plural_object_name = object_name.pluralize

            cloud_object_activity = dynamic_info[:model].new(
                cloud_object_activity_params.merge({
                    user_creator: current_user,
                    "cloud_#{module_name}_#{plural_object_name}_id".to_sym => params["#{object_name}_id".to_sym]
                })
            )

            if cloud_object_activity.save
                respond_with_successful
            else
                respond_with_error(cloud_object_activity.errors.full_messages)
            end
        end

        # @controller_action_param :complete [Boolean] Wheter this activity is complete or not
        # @return [Json] Json that contains wheter the update of the activity was successful or not. 
        #     If it is not successful, it returs an error message
        # @description Updates the activity based on the id of the *cloud_object* and its own id.
        # @example
        #     # Executing this controller's activity from javascript's frontend
        #     let ticket_id = 1;
        #     let action_id = 22;
        #     data = {
        #         ticket_action: {
        #             complete: true
        #         }
        #     };
        #     this.http.put(`127.0.0.1/help/tickets/${ticket_id}/activities/${action_id}`, data);
        def update
            return respond_with_not_found unless @cloud_object_activity

            if @cloud_object_activity.update(cloud_object_activity_params)
                respond_with_successful()
            else
                respond_with_error(@cloud_object_activity.errors.full_messages)
            end
        end

        private


        # @return [void]
        # @description Sets the variable @cloud_object_activity. The variable contains the activity 
        #     to be updated based on the id of the *cloud_object* and the id of the *activity*
        # @example
        #     #suppose params[:ticket_id] = 1
        #     #suppose params[:id] = 44
        #     puts @cloud_object_activity # will display nil
        #     set_cloud_object_activity
        #     puts @cloud_object_activity # will display an instance of CloudHelp:Ticket::Action
        def set_cloud_object_activity
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize

            @cloud_object_activity = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_activities.id = #{params[:id]}",
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_#{plural_object_name}_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

        # @return [Parameters] Allowed parameters for the activity
        # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
        #     Allowed params are _:type_, _:instructions_, _:deadline_, _:complete_, _:tags_. 
        #     For now, only the _:instructions_ and _:complete_ params are taking into account
        # @example
        #     # supose params contains {
        #     #    "ticket_action": {
        #     #        "id": 5,
        #     #        "type": "information",
        #     #        "complete": true,
        #     #        "tags": "Important",
        #     #        "info": "Example"
        #     #    }
        #     #}
        #     action_params = cloud_object_activity_params
        #     puts action_params
        #     # will remove _id_ and _info_ fields and only print {
        #     #    "ticket_action": {
        #     #        "type": "information",
        #     #        "complete": true,
        #     #        "tags": "Important"
        #     #    }
        #     #}
        def cloud_object_activity_params
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
                :category
            )
        end

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Ticket::ActionsController < CloudObject::ActionsController
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        #     puts info[:object_name] # will print 'ticket'
        #     info[:model].new # will return an instance of CloudHelp::Ticket::Action
        def self.dynamic_info
            module_info = lesli_classname().split("::")
            module_name = module_info[0].sub("Cloud", "").downcase
            
            {
                module_name: module_name,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Activity".constantize
            }
        end
    end
end
