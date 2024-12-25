=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

module Lesli
    module Items
            module Files


                # @return [Json] Json that contains a list of all files related to a *cloud_object*
                # @description Retrieves and returns all files associated to a *cloud_object*. The id of the
                #     *cloud_object* is within the *params* attribute. If the child class provides a block, the function is
                #     yielded sending the files as parameters. The block given *must* return the HTTP response
                # @example
                #     # Executing this controller's action from javascript's frontend
                #     let ticket_id = 1;
                #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files.json`);
                def index
                    file_model = file_model() # If there is a custom file model, it must be returned in this method
                    cloud_object_model = file_model.cloud_object_model
                    account_model = cloud_object_model.reflect_on_association(:account).klass

                    #Get filters from http request
                    filters = params[:f]

                    #Get start and final date only if the request have filters
                    unless filters.blank?
                        file_type = filters[:file_type]
                    end

                    respond_to do |format|
                        format.json do
                            @files = file_model.where(
                                "#{cloud_object_model.table_name}_id".to_sym => params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]
                            )

                            # Filter results
                            unless file_type.blank?
                                @files = @files.where(file_type: file_type)
                            end

                            @files = @files
                            .order(id: :desc).map do |file|
                                file_attributes = file.attributes
                                file_attributes["user_creator_name"] = file.user_creator&.full_name
                                file_attributes["public_url"] = file.attachment_public.url if file.attachment_public
                                file_attributes["created_at_raw"] = file_attributes["created_at"]
                                file_attributes["created_at"] = LC::Date2.new(file_attributes["created_at"]).date_time.to_s
                                file_attributes["updated_at_raw"] = file_attributes["updated_at"]
                                file_attributes["updated_at"] = LC::Date2.new(file_attributes["updated_at"]).date_time.to_s
                                file_attributes["editable"] = file.is_editable_by?(current_user)
                                file_attributes
                            end

                            if block_given?
                                yield(@files)
                            else
                                respond_with_successful(@files)
                            end
                        end

                        format.zip do

                        end
                    end
                end


                # @controller_action_param :attachment [File] The uploaded attachment
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

                    # Verifying the extension of the file. If it's valid, the block will be executed
                    decode_and_verify_file(new_file_params) do |verified_file_params|
                        file = file_model.new(verified_file_params)

                        if file.save
                            # Setting the file name in case it's blank and updating the file in case the filename changed
                            if file.name.blank?
                                file.update(
                                    name: params["#{cloud_object_model.name.demodulize.underscore}_file".to_sym][:attachment].original_filename
                                )
                            else
                                file.update({})
                            end

                            cloud_object = file.cloud_object

                            # Setting up file uploader to upload in background
                            Files::AwsUploadJob.perform_later(file)

                            if block_given?
                                yield(cloud_object, file)
                            else
                                # Registering an activity in the cloud_object
                                cloud_object.activities.create(
                                    user_creator: current_user,
                                    category: "action_create_file",
                                    description: "#{file.name} - #{file.attachment_identifier}"
                                )

                                # Returning the 200 HTTP response
                                respond_with_successful(file)
                            end
                        else
                            respond_with_error(file.errors.full_messages.to_sentence)
                        end
                    end
                end

                # @controller_action_param :attachment [File] The uploaded attachment
                # @controller_action_param :name [String] The name to be displayed
                # @controller_action_param :file_type [String] The file type of
                # @return [Json] Json that contains wheter the creation of the file was successful or not.
                #     If it is not successful, it returs an error message
                # @description Updates an existing file associated to a *cloud_object*. The id of the
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
                #     this.http.put(`127.0.0.1/help/tickets/${ticket_id}/files`, data);
                def update
                    set_file
                    return respond_with_not_found unless @file

                    # Verifying the extension of the file. If it's valid, the block will be executed
                    decode_and_verify_file(file_params) do |verified_file_params|
                        if @file.update(verified_file_params)

                            # Setting up file uploader to upload in background
                            Files::AwsUploadJob.perform_later(@file)

                            if block_given?
                                yield(@cloud_object, @file)
                            else
                                # Registering an activity in the cloud_object
                                @file.cloud_object.activities.create(
                                    user_creator: current_user,
                                    category: "action_update_file",
                                    description: "#{@file.name} - #{@file.attachment_identifier}"
                                )

                                # Returning the 200 HTTP response
                                respond_with_successful(@file)
                            end
                        else
                            respond_with_error(@file.errors.full_messages.to_sentence)
                        end
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

                    file_model = file_model()

                    disposition = "inline"
                    disposition = "attachment" if params["download"]

                    begin
                        # Sending file using CarrierWave
                        if @file.attachment_s3.file

                            # We either get the file from AWS and serve it ourselves or provide a direct AWS link with expiration time
                            if @file.size_mb && @file.size_mb > file_model.size_threshold
                                redirect_to(@file.refresh_external_url, allow_other_host: true)
                            else
                                send_data(@file.attachment_s3.read, filename: @file.attachment_s3_identifier, disposition: disposition, stream: "true")
                            end
                        elsif @file.attachment_public.file
                            redirect_to(@file.attachment_public_url, allow_other_host: true)
                        else
                            send_data(@file.attachment.read, filename: @file.attachment_identifier, disposition: disposition, stream: "true")
                        end
                    rescue => exception
                        # Logging the failure to retrieve the file
                        @file.cloud_object.activities.create(
                            user_creator: current_user,
                            category: "action_not_found_file",
                            description: "#{@file.name} - #{@file.attachment_identifier}"
                        )

                        # Returning a generic image in response if the file is not found on storage
                        redirect_to("/assets/global/generic.png")
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

                    if @file.destroy
                        if block_given?
                            yield(@cloud_object, @file)
                        else
                            # Registering an activity in the cloud_object
                            @file.cloud_object.activities.create(
                                user_creator: current_user,
                                category: "action_destroy_file",
                                description: @file.name
                            )

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
                    respond_with_successful(file_model.options(@query))
                end

                # @return [void]
                # @description Creates a zip file with all selected documents and sends it to the user. Note that files
                #      that don't belong to the current_user's account will be ignored. This method is deprecated, use
                #      the index method instead.
                # @example
                #     # Executing this controller's action from javascript's frontend
                #     this.http.get('127.0.0.1/house/projects/1/resources/files-zip-download&ids=1,2,3,4');
                def zip_download
            
                end

                protected

                def decode_and_verify_file(file_params)

                    # Verifying the extension of the file
                    extension = ""

                    if file_params[:attachment]

                        # if attachment is a string, it means that it's a base64 encoded file
                        if file_params[:attachment].is_a? String
                            # Base64 images

                            if file_params[:name]
                                file_name = file_params[:name].downcase.gsub(" ","_")
                            elsif @file
                                file_name = @file.name.downcase.gsub(" ","_")
                            else
                                file_name = "file_#{DateTime.now.strftime("%Y%m%d%H%M%S")}"
                            end

                            img_from_base64 = Base64.decode64(file_params[:attachment])

                            begin
                                extension = /(png|jpg|jpeg|exif|jfif)/.match(img_from_base64[0,16].downcase)[0]
                            rescue
                                return respond_with_error(I18n.t("core.shared.messages_warning_files_extension_not_allowed"))
                            end

                            # Due a encode issue, jpeg images are sent as jfif
                            extension = "jpeg" if extension == "jfif"
                            extension = "png"  if extension == "exif"

                            return respond_with_error(I18n.t("core.shared.messages_warning_files_extension_not_allowed")) unless file_model.verify_file_extension(extension)

                            file_path = Rails.root.join("public", "uploads", "tmp", file_name << '.' << extension)
                            File.open(file_path, 'wb') do|f|
                                f.write(img_from_base64)
                            end

                            file_params[:attachment] = File.open(Rails.root.join(file_path), "rb")
                            file_params[:size_mb] = file_params[:attachment].size.to_f / (1024*1024)
                            FileUtils.rm_rf(Rails.root.join(file_path))
                        else
                            extension = file_params[:attachment].original_filename
                            file_params[:size_mb] = file_params[:attachment].size.to_f / (1024*1024)

                            return respond_with_error(I18n.t("core.shared.messages_warning_files_extension_not_allowed")) unless file_model.verify_file_extension(extension)
                        end

                        file_params[:external_url] = nil
                    end

                    if block_given?
                        yield(file_params)
                    end
                end

                # @return [void]
                # @description This function handles the zip download based on the type of attachment that the file has.
                #     If the attachment is local, it means that the file has not yet been uploaded to S3 and will be handled
                #     accordingly
                # @example
                #     # Executing this controller's action from javascript's frontend
                #     this.http.get('127.0.0.1/house/options/project/1/files/zip&ids=1,2,3,4');
                def handle_zip_download(files)

                end

                # @return [void]
                # @descriptions Sets the variable @cloud_object based on the paremeters send in the URL. If no,
                #     cloud_object is found or it is not within the current_user's account, nil is used instead
                # @example
                #     # Imagine you are inside CloudFocus::Task::FilesController
                #     puts @cloud_object # will display nil
                #     set_cloud_object
                #     puts @cloud_object # Will display an instance of CloudFocus::Task
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
                    set_cloud_object
                    return unless @cloud_object

                    @file = @cloud_object.files.find_by(id: params[:id])
                end

                # @return [Parameters] Allowed parameters for the file
                # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
                #     Allowed params are _:name_, _:file_type_, _:attachment_
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
                #     #        "attachment": FILE_CONTENT
                #     #    }
                #     #}
                def file_params
                    file_model = file_model() # If there is a custom file model, it must be returned in this method
                    cloud_object_model = file_model.cloud_object_model

                    params.fetch(
                        "#{cloud_object_model.name.demodulize.underscore}_file".to_sym, {}
                    ).permit(
                        :name,
                        :attachment,
                        :file_type
                    )
                end

                # @return [CloudObject::File] The file model that the controller will handle
                # @descriptions Constantizes and returns the file model associated to this controller. This method
                #      can be overrided by the implementation in the child controller
                # @example
                #     # Suppose you are inside CloudHelp::Ticket::FilesController
                #     puts file_model().new
                #     # This will display a new instance of CloudHelp::Ticket::File
                def file_model
                    self.class.name.gsub("Controller","").singularize.constantize
                end
            end
        end
end
