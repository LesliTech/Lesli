module CloudObject
    class FilesController < ApplicationController
        before_action :set_cloud_object_file, only: [:show]

        # GET cloud_objects/1/files
        def index
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            
            cloud_object_id = params["#{object_name}_id".to_sym]
            @cloud_object_files = dynamic_info[:model].where(
                "cloud_#{module_name}_#{object_name}s_id".to_sym => cloud_object_id
            ).order(id: :desc)
            responseWithSuccessful(@cloud_object_files)
        end

        # POST cloud_objects/1/files
        def create
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 

            cloud_object_file = dynamic_info[:model].new(cloud_object_file_params)
            cloud_object_file.name = cloud_object_file.file.filename if cloud_object_file.name.blank?

            if cloud_object_file.save
                responseWithSuccessful

                cloud_object = cloud_object_file.cloud_object
                message = I18n.t(
                    "cloud_#{module_name}.controllers.#{object_name}.files.notifications.created",
                    "#{object_name}_id".to_sym => cloud_object.id
                )
                cloud_object.notify_subscribers(message, :file_created)
            else
                responseWithError(cloud_object_file.errors.full_messages.to_sentence)
            end
        end

        # GET cloud_objects/1/files/1
        def show
            redirect_to Rails.application.routes.url_helpers.rails_blob_path(
                @cloud_object_file.file,
                disposition: "attachment",
                only_path: true
            )
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_cloud_object_file
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            @cloud_object_file = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_files.id = #{params[:id]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_#{object_name}s_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{object_name}s.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

        # Only allow a trusted parameter "white list" through.
        def cloud_object_file_params
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 

            params.require(
                "#{object_name}_file".to_sym
            ).permit(
                :name,
                :file,
                "cloud_#{module_name}_#{object_name}s_id".to_sym
            )
        end

        # Obtains model, module and object name.
        # For example, dynamicModel would be CloudHelp::Ticket::File, module_name would be 'help' and object_name would be 'ticket'
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::File".constantize
            }
        end
    end
end
