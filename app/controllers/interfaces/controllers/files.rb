module Interfaces::Controllers::Files
    require 'zip'
    require 'aws-sdk-s3'

    # @return [Json] Json that contains a list of all files related to a *cloud_object*
    # @description Retrieves and returns all files associated to a *cloud_object*. The id of the 
    #     *cloud_object* is within the *params* attribute. If the child class provides a block, the function is
    #     yielded sending the files as parameters. The block given *must* return the HTTP response
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files`);
    def index
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        cloud_object_model = file_model.cloud_object_model
        
        @files = file_model.where(
            "#{cloud_object_model.table_name}_id".to_sym => params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]
        ).order(id: :desc).map do |file|
            file_attributes = file.attributes
            file_attributes["created_at_raw"] = file_attributes["created_at"]
            file_attributes["created_at"] = LC::Date.to_string_datetime(file_attributes["created_at"])
            file_attributes["editable"] = file.is_editable_by?(current_user)
            file_attributes
        end
        
        if block_given?
            yield(@files)
        else
            respond_with_successful(@files)
        end
    end


    # @controller_action_param :attachment_local [File] The uploaded attachment
    # @controller_action_param :name [String] The name to be displayed
    # @controller_action_param :file_type [String] The file type of 
    # @return [Json] Json that contains wheter the creation of the file was successful or not. 
    #     If it is not successful, it returs an error message
    # @description Creates a new file associated to a *cloud_object*. The id of the 
    #     *cloud_object* is within the *params* attribute. If the child class provides a block, the function is
    #     yielded sending the cloud_object as first param, and the file as second param.
    #     The block given *must* return the HTTP response
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let data = {
    #         ticket_file: {
    #             file: FILE_CONTENT
    #             name: "contract_information"
    #         }
    #     };
    #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/files`, data);
    def create
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        cloud_object_model = file_model.cloud_object_model

        set_cloud_object
        new_file_params = file_params.merge(
            user_creator: current_user,
            cloud_object: @cloud_object
        )

        # Verifying the extension of the file
        extension = ""
        extension = new_file_params[:attachment_local].original_filename if new_file_params[:attachment_local]
        extension = new_file_params[:attachment].original_filename if new_file_params[:attachment]
        return respond_with_error(I18n.t("core.shared.notification_error_file_type_not_allowed")) unless file_model.verify_file_extension(extension)

        file = file_model.new(new_file_params)
        if file.save
            # Setting the file name in case it's blank
            file.update(
                name: (file.attachment_local_identifier || file.attachment_identifier)
            ) if file.name.blank?

            cloud_object = file.cloud_object

            # Registering an activity in the cloud_object
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_create_file",
                description: file.name
            )

            # Setting up file uploader to upload in background
            Files::AwsUploadJob.perform_later(file)
            
            if block_given?
                yield(cloud_object, file)
            else
                # Returning the 200 HTTP response
                respond_with_successful(file)
            end
        else
            respond_with_error(file.errors.full_messages.to_sentence)
        end
    end

    # @return [void]
    # @description Prepares the files for download and redirects the explorer to a new window,
    #     where they can view/download the file. The id of the 
    #     *cloud_object* and the id of the *file* are within the *params* attribute
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let file_id = 5;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files/${file_id}`);
    def show
        set_file
        return respond_with_not_found unless @file
        
        disposition = "inline"
        disposition = "attachment" if params["download"]
        
        # Sending file using CarrierWave
        if @file.attachment.file
            send_data(@file.attachment.read, filename: @file.name, disposition: disposition, stream: "true")
        else
            send_data(@file.attachment_local.read, filename: @file.name, disposition: disposition, stream: "true")
        end
    end

    # @return [Json] A response that contains wheter the file was deleted or not.
    #     If it is not successful, it returns an error message
    # @description Deletes a file from the database based on the id of the *cloud_object* and its own id. If a block is given,
    #     the function is yielded with no arguments after the file is destroyed
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     let file_id = 22;
    #     this.http.delete(`127.0.0.1/help/tickets/${ticket_id}/files/${file_id}`);
    def destroy
        set_file
        return respond_with_not_found unless @file
        return respond_with_unauthorized unless @file.is_editable_by?(current_user)

        # We remove the attachment from local and S3 before deleting the file
        @file.update!(attachment: nil)
        @file.update!(attachment_local: nil)

        if @file.destroy
            # Registering an activity in the cloud_object
            @file.cloud_object.activities.create(
                user_creator: current_user,
                category: "action_destroy_file",
                description: @file.name
            )

            if block_given?
                yield
            else
                respond_with_successful
            end
        else
            respond_with_error(@file.errors.full_messages.to_sentence)
        end
    end

    # @return [void]
    # @description Returns a list of needed information in order to create a file.
    #     For the time being, it only returns a list of all file types
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.http.get('127.0.0.1/house/options/project/files')
    def options
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        respond_with_successful(file_model.options)
    end

    # @return [void]
    # @description Creates a zip file with all selected documents and sends it to the user. Note that files
    #      that don't belong to the current_user's account will be ignored
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.http.get('127.0.0.1/house/options/project/1/files/zip&ids=1,2,3,4');
    def zip_download
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        cloud_object_model = file_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        files = file_model.joins(
            :cloud_object
        ).where(
            "#{file_model.table_name}.id in (#{params[:ids]})"
        ).where(
            "#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}"
        )

        handle_zip_download(files)
    end

    protected

    # @return [void]
    # @description This function handles the zip download based on the type of attachment that the file has.
    #     If the attachment is local, it means that the file has not yet been uploaded to S3 and will be handled
    #     accordingly
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.http.get('127.0.0.1/house/options/project/1/files/zip&ids=1,2,3,4');
    def handle_zip_download(files)
        s3 = LC::Config::Providers::Aws::S3.new()

        zip_stream = ::Zip::OutputStream.write_buffer do |zip|
            files.each do |file|
                # Handling an AWS S3 file
                if file.attachment.file
                    file_filepath = file.attachment.current_path
                    filename = file.attachment_identifier
                    file_obj = s3.get_object(file_filepath)
                    zip.put_next_entry filename
                    zip.print file_obj.body.read
                # Haindling a local storage file
                elsif file.attachment_local.file
                    file_filepath = file.attachment_local.current_path
                    filename = file.attachment_local_identifier
                    next unless ::File.exist?(file_filepath)
                    zip.put_next_entry filename
                    zip.print IO.binread(file_filepath)
                end
            end
        end
        zip_stream.rewind
        send_data zip_stream.read, filename: "all_documents_#{Date.today.strftime('%d_%B_%Y')}.zip", type: 'application/zip'
    end

    def set_cloud_object
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        cloud_object_model = file_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @cloud_object = cloud_object_model.find_by(
            id: params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym],
            "#{account_model.table_name}_id".to_sym => current_user.account.id
        )
    end

    # @return [void]
    # @description Sets the variable @file. The variable contains the file 
    #     to be updated based on the id of the *cloud_object* and the id of the *file*. The variable
    #     will only be available if the file belongs to the current_user's account
    # @example
    #     #suppose params[:ticket_id] = 1
    #     #suppose params[:id] = 44
    #     puts @file # will display nil
    #     set_file
    #     puts @file # will display an instance of CloudHelp:Ticket::File
    def set_file
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        cloud_object_model = file_model.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass

        @file = file_model.joins(:cloud_object).where(
            "#{cloud_object_model.table_name}.id = #{params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]}",
            "#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}"
        ).find_by(
            id: params[:id]
        )
    end

    # @return [Parameters] Allowed parameters for the file
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are _:name_, _:file_type_, _:attachment_local_
    # @example
    #     # supose params contains {
    #     #    "ticket_file": {
    #     #        "id": 5,
    #     #        "name": "User Contract",
    #     #        "file": FILE_CONTENT,
    #     #        "ticket_id": 55,
    #     #        "word": false
    #     #    }
    #     #}
    #     file_params = file_params
    #     puts file_params
    #     # will remove _id_ and _word_ fields and only print {
    #     #    "ticket_file": {
    #     #        "name": "User Contract",
    #     #        "attachment_local": FILE_CONTENT
    #     #    }
    #     #}
    def file_params
        file_model = file_model() # If there is a custom file model, it must be returned in this method
        cloud_object_model = file_model.cloud_object_model

        params.require(
            "#{cloud_object_model.name.demodulize.underscore}_file".to_sym
        ).permit(
            :name,
            :attachment_local,
            :file_type
        )
    end
    
    def file_model
        self.class.name.gsub("Controller","").singularize.constantize
    end
end
    