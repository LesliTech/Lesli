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
    class File < ApplicationLesliRecord
        self.abstract_class = true
        mount_uploader :attachment_s3,  AwsUploader
        mount_uploader :attachment,     LocalUploader

        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

        enum file_type: {}

        def destroy
            update(attachment: nil, attachment_s3: nil)

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

        def self.lesli_classname
            self.name
        end


        def self.size_threshold
            return 0
        end
    end
end
