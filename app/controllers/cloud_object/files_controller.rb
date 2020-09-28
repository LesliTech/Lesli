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
@description Base controller for *file* core entity

=end
    class FilesController < ApplicationLesliController
        require 'zip'
        require 'aws-sdk-s3'

        before_action :set_cloud_object_file, only: [:show, :destroy]

=begin
@return [Json] Json that contains a list of all files related to a *cloud_object*
@description Retrieves and returns all files associated to a *cloud_object*. The id of the 
    *cloud_object* is within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files`);
=end
        def index
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize
            
            cloud_object_id = params["#{object_name}_id".to_sym]
            @cloud_object_files = dynamic_info[:model].where(
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym => cloud_object_id
            ).order(id: :desc).map do |file|
                file_attributes = file.attributes
                file_attributes["created_at_raw"] = file_attributes["created_at"]
                file_attributes["created_at"] = LC::Date.to_string_datetime(file_attributes["created_at"])
                file_attributes["editable"] = file.is_editable_by?(current_user)
                file_attributes
            end
            respond_with_successful(@cloud_object_files)
        end

=begin
@controller_action_param :file [File] The uploaded file
@controller_action_param :name [String] The name to be displayed
@return [Json] Json that contains wheter the creation of the file was successful or not. 
    If it is not successful, it returs an error message
@description Creates a new file associated to a *cloud_object*. The id of the 
    *cloud_object* is within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let data = {
        ticket_file: {
            file: FILE_CONTENT
            name: "contract_information"
        }
    };
    this.http.post(`127.0.0.1/help/tickets/${ticket_id}/files`, data);
=end
        def create
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 
            model = dynamic_info[:model]
            subscriber_model = dynamic_info[:subscriber_model]
            plural_object_name = object_name.pluralize
        
            new_file_params = 
            cloud_object_file_params.merge(
                user_creator: current_user,
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym => params["#{object_name}_id".to_sym]
            )
            
            extension = ""
            extension = new_file_params[:attachment_local].original_filename if new_file_params[:attachment_local]
            extension = new_file_params[:attachment].original_filename if new_file_params[:attachment]

            return respond_with_error(I18n.t('core.shared.notification_error_file_type_not_allowed')) unless model.verify_file_extension(extension)

            cloud_object_file = model.new(new_file_params)

            if cloud_object_file.save

                cloud_object_file.update(
                    name: (cloud_object_file.attachment_local_identifier || cloud_object_file.attachment_identifier)
                ) if cloud_object_file.name.blank?

                cloud_object = cloud_object_file.cloud_object
                # Notify Subscribers
                # message = I18n.t(
                #    "cloud_#{module_name}.controllers.#{object_name}.files.notifications.created",
                #    "#{object_name}_id".to_sym => cloud_object.id
                #)
                #subscriber_model.notify_subscribers(cloud_object, message, :file_created)

                # Register Activity
                cloud_object.activities.create(
                    user_creator: current_user,
                    category: "action_create_file",
                    description: cloud_object_file.name
                )

                # Setting up file uploader to upload in background
                Files::AwsUploadJob.perform_later(cloud_object_file)

                respond_with_successful(cloud_object_file)
            else
                respond_with_error(cloud_object_file.errors.full_messages.to_sentence)
            end
        end

=begin
@return [void]
@description Prepares the files for download and redirects the explorer to a new window,
    where they can view/download the file. The id of the 
    *cloud_object* and the id of the *file* are within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let file_id = 5;
    this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files/${file_id}`);
=end
        def show
            return respond_with_not_found unless @cloud_object_file
            
            disposition = "inline"
            disposition = "attachment" if params["download"]
            
            # Sending file using CarrierWave
            if @cloud_object_file.attachment.file
                send_data(@cloud_object_file.attachment.read, filename: @cloud_object_file.name, disposition: disposition, stream: 'true')
            else
                send_data(@cloud_object_file.attachment_local.read, filename: @cloud_object_file.name, disposition: disposition, stream: 'true')
            end
        end

=begin
@return [Json] A response that contains wheter the file was deleted or not.
If it is not successful, it returns an error message
@description Deletes a file from the database based on the id of the *cloud_object* and its own id.
@example
# Executing this controller's action from javascript's frontend
let ticket_id = 1;
let file_id = 22;
this.http.delete(`127.0.0.1/help/tickets/${ticket_id}/files/${file_id}`);
=end
        def destroy
            return respond_with_not_found unless @cloud_object_file
            return respond_with_unauthorized unless @cloud_object_file.is_editable_by?(current_user)

            # We remove the attachment from local and S3 before deleting the file
            @cloud_object_file.update!(attachment: nil)
            @cloud_object_file.update!(attachment_local: nil)

            if @cloud_object_file.destroy
                respond_with_successful

                # Register Activity
                @cloud_object_file.cloud_object.activities.create(
                    user_creator: current_user,
                    category: "action_destroy_file",
                    description: @cloud_object_file.name
                )
            else
                respond_with_error(@cloud_object_file.errors.full_messages.to_sentence)
            end
        end

=begin
@return [void]
@description Returns a list of needed information in order to create a file.
    For the time being, it only returns a list of all file types
@example
    # Executing this controller's action from javascript's frontend
    this.http.get('127.0.0.1/house/options/project/files');
=end
        def options
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]
            respond_with_successful(model.options)
        end

=begin
@return [void]
@descirption Creates a zip file with all selected documents and sends it to the user
@example
    # Executing this controller's action from javascript's frontend
    this.http.get('127.0.0.1/house/options/project/1/files/zip&ids=1,2,3,4');
=end
        def zip_download
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize

            files = model.joins(
                :cloud_object
            ).where(
                "cloud_#{module_name}_#{object_name}_files.id in (#{params[:ids]})"
            ).where(
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            )

            handle_zip_download(files)
        end

        protected

        def handle_zip_download(files)
            s3 = LC::Config::Providers::Aws::S3.new()

            zip_stream = ::Zip::OutputStream.write_buffer do |zip|
                files.each do |object_file|
                    if object_file.attachment.file
                        object_file_filepath = object_file.attachment.current_path
                        filename = object_file.attachment_identifier
                        file_obj = s3.get_object(object_file_filepath)
                        zip.put_next_entry filename
                        zip.print file_obj.body.read
                    elsif object_file.attachment_local.file
                        object_file_filepath = object_file.attachment_local.current_path
                        filename = object_file.attachment_local_identifier
                        next unless ::File.exist?(object_file_filepath)
                        zip.put_next_entry filename
                        zip.print IO.binread(object_file_filepath)
                    end
                end
            end
            zip_stream.rewind
            send_data zip_stream.read, filename: "all_documents_#{Date.today.strftime('%d_%B_%Y')}.zip", type: 'application/zip'
        end

=begin
@return [void]
@description Sets the variable @cloud_object_file. The variable contains the file 
    to be updated based on the id of the *cloud_object* and the id of the *file*
@example
    #suppose params[:ticket_id] = 1
    #suppose params[:id] = 44
    puts @cloud_object_file # will display nil
    set_cloud_object_file
    puts @cloud_object_file # will display an instance of CloudHelp:Ticket::File
=end
        def set_cloud_object_file
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize

            @cloud_object_file = dynamic_info[:model].joins(:cloud_object).where(
                "cloud_#{module_name}_#{object_name}_files.id = #{params[:id]}",
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_#{plural_object_name}_id = #{params["#{object_name}_id".to_sym]}",
                "cloud_#{module_name}_#{plural_object_name}.cloud_#{module_name}_accounts_id = #{current_user.account.id}"
            ).first
        end

=begin
@return [Parameters] Allowed parameters for the file
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    Allowed params are _:name_, _:file_.
@example
    # supose params contains {
    #    "ticket_file": {
    #        "id": 5,
    #        "name": "User Contract",
    #        "file": FILE_CONTENT,
    #        "ticket_id": 55,
    #        "word": false
    #    }
    #}
    file_params = cloud_object_file_params
    puts file_params
    # will remove _id_ and _word_ fields and only print {
    #    "ticket_file": {
    #        "name": "User Contract",
    #        "file": FILE_CONTENT
    #    }
    #}
=end
        def cloud_object_file_params
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 
            plural_object_name = object_name.pluralize

            params.require(
                "#{object_name}_file".to_sym
            ).permit(
                :name,
                :attachment_local,
                :attachment,
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym,
                :file_type
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Ticket::FilesController < CloudObject::FilesController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:object_name] # will print 'ticket'
    info[:model].new # will return an instance of CloudHelp::Ticket::File
    info[:subscriber_model].new # will return an instance of CloudHelp::Ticket::Subscriber
=end
        def self.dynamic_info
            module_info = lesli_classname().split("::")
            
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::File".constantize
                #subscriber_model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end

    end
end
