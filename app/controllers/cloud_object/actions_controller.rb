module CloudObject
    class ActionsController < ApplicationController
        before_action :set_cloud_object_action, only: [:update]

        # GET /cloud_objects/1/actions
        def index
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            
            cloud_object_id = params["#{object_name}_id".to_sym]
            @cloud_object_actions = dynamic_info[:model].where(
                "cloud_#{module_name}_#{object_name}s_id".to_sym => cloud_object_id
            ).order(id: :desc)
            responseWithSuccessful(@cloud_object_actions)
        end

        # POST cloud_objects/1/actions
        def create
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 

            cloud_object_actions = dynamic_info[:model].new(cloud_object_action_params)

            if cloud_object_actions.save
                responseWithSuccessful

                cloud_object = cloud_object_actions.cloud_object
                message = I18n.t(
                    "cloud_#{module_name}.controllers.#{object_name}.actions.notifications.created",
                    "#{object_name}_id".to_sym => cloud_object.id
                )
                cloud_object.notify_subscribers(message, :action_created)
            else
                responseWithError(cloud_object_actions.errors.full_messages.to_sentence)
            end
        end

        # PATCH/PUT /cloud_objects/1/actions/1
        def update
            if @cloud_object_action.update(cloud_object_action_params)
                responseWithSuccessful
            else
                responseWithError(cloud_object_actions.errors.full_messages.to_sentence)
            end
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_cloud_object_action
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            @cloud_object_action = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_actions.id = #{params[:id]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_#{object_name}s_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

        # Only allow a trusted parameter "white list" through.
        def cloud_object_action_params
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 

            params.require(
                "#{object_name}_action".to_sym
            ).permit(
                :id,
                :type,
                :instructions,
                :deadline,
                :complete,
                :tags,
                "cloud_#{module_name}_#{object_name}s_id".to_sym
            )
        end

        # Obtains model, module and object name.
        # For example, model would be CloudHelp::Ticket::Action, module_name would be 'help' and object_name would be 'ticket'
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Action".constantize
            }
        end
    end
end
