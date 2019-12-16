module CloudObject
    class DiscussionsController < ApplicationController

        # GET /cloud_object/1/discussions
        def index
            responseWithSuccessful(
                dynamic_info[:dynamic_model].detailed_info(
                    current_user.account, params["#{dynamic_info[:object_name]}_id".to_sym]
                )
            )
        end

        # POST /cloud_object/1/discussions
        def create
            cloud_object_dicussion = dynamic_info[:dynamic_model].new(
                cloud_object_discussion_params.merge({
                    users_id: current_user.id
                })
            )

            if cloud_object_dicussion.save
                responseWithSuccessful(cloud_object_dicussion)

                cloud_object = cloud_object_dicussion.cloud_object
                message = I18n.t(
                    "cloud_#{dynamic_info[:module_name]}.controllers.#{dynamic_info[:object_name]}.discussions.notifications.created",
                    "#{dynamic_info[:object_name]}_id".to_sym => cloud_object.id
                )
                cloud_object.notify_subscribers(message, :comment_created)
            else
                responseWithError(cloud_object_dicussion.errors.full_messages.to_sentence)
            end

        end

        private

        # Only allow a trusted parameter "white list" through.
        def cloud_object_discussion_params
            params.require("#{dynamic_info[:object_name]}_discussion".to_sym).permit(
                :content,
                "cloud_#{dynamic_info[:module_name]}_#{dynamic_info[:object_name]}s_id".to_sym,
                "cloud_#{dynamic_info[:module_name]}_#{dynamic_info[:object_name]}_discussions_id".to_sym
                )
        end
        
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                dynamic_model: "#{module_info[0]}::#{module_info[1]}::Discussion".constantize
            }
        end

    end
end
