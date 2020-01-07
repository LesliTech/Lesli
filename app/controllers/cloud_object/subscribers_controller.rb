module CloudObject
    class SubscribersController < ApplicationController
        before_action :set_cloud_object_subscriber, only: [:update, :destroy]

        # GET cloud_objects/1/subscribers
        def index
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            cloud_object_model = dynamic_info[:cloud_object_model]
            dynamic_model = dynamic_info[:model]

            cloud_object_id = params["#{object_name}_id".to_sym]
            events = dynamic_model.subscription_events(
                cloud_object_model.find(cloud_object_id),
                current_user
            )
            responseWithSuccessful(events)
        end

        # POST cloud_objects/1/subscribers
        def create
            cloud_object_subscriber = dynamic_info[:model].new(
                cloud_object_subscriber_params.merge(
                    user: current_user
                )
            )
            if cloud_object_subscriber.save
                responseWithSuccessful(cloud_object_subscriber)
            else
                responseWithError(cloud_object_subscriber.errors.full_messages.to_sentence)
            end
        end

        # PUT cloud_objcets/1/subscribers/1
        def update
            if @cloud_object_subscriber.update(cloud_object_subscriber_params)
                responseWithSuccessful
            else
                responseWithError(cloud_object_subscriber_params.errors.full_messages.to_sentence)
            end
        end

        def destroy
            if @cloud_object_subscriber.destroy
                responseWithSuccessful
            else
                responseWithError(cloud_object_subscriber_params.errors.full_messages.to_sentence)
            end
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_cloud_object_subscriber
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            @cloud_object_subscriber = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_subscribers.id = #{params[:id]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_#{object_name}s_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

        # Obtains model, module and object name.
        # For example, model would be CloudHelp::Ticket::Subscriber, module_name would be 'help' and object_name would be 'ticket'
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize,
                cloud_object_model: "#{module_info[0]}::#{module_info[1]}".constantize
            }
        end

        # Setting up the white list for subscriber
        def cloud_object_subscriber_params
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            params.require(:subscriber).permit(
                :event,
                :notification_type,
                "cloud_#{module_name}_#{object_name}s_id".to_sym
            )
        end
        
    end
end
