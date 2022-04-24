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
class CloudObject::File < ApplicationLesliRecord
    include ActiveModel::Dirty

    self.abstract_class = true
    mount_uploader :attachment_s3,      AwsUploader
    mount_uploader :attachment_public,  PublicUploader
    mount_uploader :attachment,         LocalUploader

    before_save  :set_public_accesibility
    after_update :update_attachment

    belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

    validates_presence_of :attachment, on: :create
    validates_presence_of :file_type

    enum file_type: {}

    # @return [String] This method will return the path of the file
    # @param current_user [User] The user that made a request to execute this method
    # @param query [Hash] A hash that contains the query params of the request
    # @description This method return the path that should be used to get the file via HTTP GET.
    #       On the query param it receive the custom base path, for example to serve files via the CloudDispatcher.
    # @example
    #       query[:base_path] = "/api"
    #       image_path = project.files.first.show_url(current_user, query) if project.files.first
    def show_url current_user, query
        cloud_object_controller = self.cloud_object.class.lesli_classname.underscore.split("/").last.pluralize

        "#{query[:base_path]}/#{cloud_object_controller}/#{self.cloud_object.id}/files/#{self.id}"
    end


    # @return [void]
    # @description Overrides the destroy method to set all attachments to nil. This will cause the attachments to be deleted
    # @example
    #     ticket = CloudHelp::Ticket.last
    #     ticket.files.first.destroy # This will trigger the destroy method
    def destroy
        update(attachment: nil, attachment_s3: nil, attachment_public: nil)

        super
    end

    # @return [User] This method will always return nil
    # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
    #   ApplicationLesliRecord will work without issues
    def user_main
        return nil
    end

    # @return [String] A string representing a 1-minute valid external URL to download the file
    # @description Checks if this file has an external URL associated and it is valid. If it is not, it refreshes the URL
    #     and then returns it. All urls are valid for 1 minute after creation
    # @example
    #     # If executed from the controller's show action
    #     @file = current_user.account.help.tickets.find(1).files.find(2)
    #     @file.refresh_external_url
    #     redirect_to @file.external_url
    def refresh_external_url
        return external_url if (external_url && (external_url_expiration_date > LC::Date.now + 5.seconds))

        client = LC::Config::Providers::Aws::S3.new()
        object_key = [
            "storage",
            self.class.lesli_classname.underscore.sub("/file", ""),
            self.cloud_object.id,
            self.attachment_s3_identifier
        ].join("/")

        object_url = client.generate_object_url(object_key, expires_in_seconds: 60)
        self.update!(
            external_url: object_url,
            external_url_expiration_date: LC::Date.now + 1.minute
        )

        external_url
    end

    # @return [Hash] A list of options needed to create a File.
    # @description Returns lists of all fields needed to create a file. For the time being, it only returns a list of
    #     all available file types
    # @example
    #     options = CloudHelp::File.options
    #     puts options.to_json
    #     # This will display something like
    #     # {
    #     #     value: "draft", text: "draft",
    #     #     value: "images", text: "images"
    #     # }
    def self.options(query)
        data_file_types = []
        self.file_types.each do |key, value|
            data_file_types.push({
                value: key,
                text: value
            })
        end

        {
            file_types: data_file_types
        }
    end

    # @return [Array] An array of strings that contains all available file extensions to be uploaded
    # @description Returns an array that contains all file extensions that are supported on this model
    # @example
    #     puts CloudHelp::Sla::File.allowed_file_extensions
    #     # This will display something like
    #     # [
    #     #     "jpeg",
    #     #     "gif",
    #     #     "pdf",
    #     #     "docx"
    #     # ]
    def self.allowed_file_extensions
        return nil
    end

    # @return [Boolean] If the extension of the required file is allowed or not
    # @param filename [String] the name of the file that will be uploaded
    # @description Check if the extension of 'filename' is contained in the *allowed_file_extensions* method.
    #     If it is, returns true, otherwise, returns false.
    # @example
    #     puts CloudHelp::Sla::File.verify_file_extension("test.docx") # This will return true
    #     puts CloudHelp::Sla::File.verify_file_extension("test.pptx") # This will return false
    def self.verify_file_extension(filename)
        allowed_file_extensions_ = self.allowed_file_extensions

        return true unless allowed_file_extensions_

        allowed_file_extensions_.each do |file_extesion|
            if filename.downcase.end_with?(file_extesion)
                return true
            end
        end

        return false
    end

    # @return [Class] The class of the association 'belongs_to'
    # @description All files belong to a *cloud_object*. This method returns the specific class of
    #     that cloud_object.
    # @example
    #     puts DeutscheLeibrenten::Project::File.cloud_object_model.new # This will display an instance of DeutscheLeibrenten::Project
    def self.cloud_object_model
        self.reflect_on_association(:cloud_object).klass
    end

    # @return [String] The lesli classname associated with this new_record
    # @description Some objects inherit the functionality fron other parent objects. Deutsche Leibrenten is a clear example of this.
    #     This method ensures that the associations obtained by child methods that do not follw the lesli standard, will use a class
    #     that does follow it to calculate foreign keys, associations, and so on. Since most models do follow the standard, by default,
    #     the lesli classname is the same name of the class
    # @example
    #     puts CloudHouse::Project.lesli_classname # This will return "CloudHouse::Project"
    #     puts DeutscheLEibrenten::Project.lesli_classname # This will also return "CloudHouse::Project"
    def self.lesli_classname
        self.name
    end

    # @return [Integer] The size threshold used to determine whether to serve images from the server, or from AWS
    # @description This methods returns a number that indicates the max size, im MB, threshold used to serve images from the server.
    #     If the size of the file is greater than this threshould, AWS will be used to serve the image instead.
    # @example
    #     CloudHouse::Project::File.size_threshould # This will display the configured size threshould
    def self.size_threshold

        lesli_size_threshold = Rails.application.config.lesli.dig(:configuration, :files, :size_threshold)

        return lesli_size_threshold if lesli_size_threshold

        return 0

    end

    protected

    # @return [Boolean] True if the objects on this class should be publicly accessible. False otherwise.
    # @descriptions This method returns whether all the objects on this model are publicly accessible. By default, they are not
    # @example
    #     CloudHelp::Ticket::File.public_accesibility # This will return false, unless this method is overriden on that specific model
    def self.public_accesibility
        return false
    end

    # @return [void]
    # @description This is an before_save callback that sets the param "public" depending on the value returned by the static method
    #     "public accesibility"
    # @example
    #     # Note that this method is not called directly
    #     file = current_user.account.house.projects.files.create({...}) # it will be executed here, before saving the record
    def set_public_accesibility
        if new_record?
            self.public = self.class.public_accesibility
        end
    end

    # @return [void]
    # @description This is an after_update callback that moves the attachment between public and private folders if needed. When the "public"
    #    attribute of the model is changed, this method will move the attachment from the normal directory to the public one and vice versa
    # @example
    #     # Note that this method is not called directly
    #     file = CloudFocus::Task::File.last
    #     file.update!(public: true)
    def update_attachment
        if saved_change_to_public?
            if saved_changes[:public][1]
                # We move the attachment from attachment_s3 to attachment_public
                update!(attachment_public: attachment_s3)

                if attachment_public
                    update!(attachment_s3: nil)
                end
            else
                # We move the attachment from attachment_public to attachment_s3
                update!(attachment_s3: attachment_public)

                if attachment_s3
                    update!(attachment_public: nil)
                end
            end
        end
    end
end
