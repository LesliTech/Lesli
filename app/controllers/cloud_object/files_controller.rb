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
    class FilesController < ApplicationController
        before_action :set_cloud_object_file, only: [:show]

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
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]
            plural_object_name = object_name.pluralize
            
            cloud_object_id = params["#{object_name}_id".to_sym]
            @cloud_object_files = dynamic_info[:model].where(
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym => cloud_object_id
            ).order(id: :desc)
            responseWithSuccessful(@cloud_object_files)
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
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 
            subscriber_model = dynamic_info[:subscriber_model]
            plural_object_name = object_name.pluralize

            cloud_object_file = dynamic_info[:model].new(
                cloud_object_file_params.merge(
                    "cloud_#{module_name}_#{plural_object_name}_id".to_sym => params["#{object_name}_id".to_sym]
                )
            )
            cloud_object_file.name = cloud_object_file.file.filename if cloud_object_file.name.blank?

            if cloud_object_file.save
                responseWithSuccessful

                cloud_object = cloud_object_file.cloud_object
                message = I18n.t(
                    "cloud_#{module_name}.controllers.#{object_name}.files.notifications.created",
                    "#{object_name}_id".to_sym => cloud_object.id
                )
                #subscriber_model.notify_subscribers(cloud_object, message, :file_created)
            else
                responseWithError(cloud_object_file.errors.full_messages.to_sentence)
            end
        end

=begin
@return [void]
@description Preparas the files for download and redirects the explorer to a new window,
    where they can view/download the file. The id of the 
    *cloud_object* and the id of the *file* are within the *params* attribute
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 1;
    let file_id = 5;
    this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files/${file_id}`);
=end
        def show
            redirect_to Rails.application.routes.url_helpers.rails_blob_path(
                @cloud_object_file.file,
                disposition: "attachment",
                only_path: true
            )
        end

        private

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
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name] 
            plural_object_name = object_name.pluralize

            params.require(
                "#{object_name}_file".to_sym
            ).permit(
                :name,
                :file,
                "cloud_#{module_name}_#{plural_object_name}_id".to_sym
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
        def dynamic_info
            module_info = self.class.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::File".constantize,
                #subscriber_model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end
    end
end
