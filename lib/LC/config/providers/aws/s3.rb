=begin

Copyright (c) 2021, all rights reserved.

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
module LC
    module Config
        module Providers
            module Aws
                class S3

                    # @return [void]
                    # @description Initializes a wrapper for a Aws::S3::Client using the credentials stored in
                    #     Rails.application.credentials.providers[:aws][:s3]. The arguments required in the credentials are
                    #     region, access_key_id, secret_access_key and bucket.
                    # @example
                    #     client = LC::Config::Providers::Aws::S3.new
                    #     s3.get_object("storage/cloud_house/projects/1/files/112-my-file.docx")
                    def initialize
                        @client = ::Aws::S3::Client.new()
                        @resource = ::Aws::S3::Resource.new()
                        @signer = ::Aws::S3::Presigner.new()
                        if Rails.application.credentials.providers[:aws][:s3]
                            s3_credentials = {
                                region: Rails.application.credentials.providers[:aws][:s3][:region],
                                access_key_id: Rails.application.credentials.providers[:aws][:s3][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:s3][:secret_access_key]
                            }

                            @client = ::Aws::S3::Client.new(s3_credentials)
                            @resource = ::Aws::S3::Resource.new(s3_credentials)
                            @signer = ::Aws::S3::Presigner.new(client: @client)

                            self
                        end
                    end

                    # @param key [String] The object identifier within the bucked
                    # @return [Aws::S3::Types::GetObjectOutput] An output stream associated to the S3 object.
                    # @description Connects to Aws and retrieves the object associated to the **key** argument. This object can then be
                    #     read as an output stream and send to the frontend
                    # @example
                    #     file_path = "storage/cloud_house/projects/1/files/112-my-file.docx"
                    #     file_name = "my-file.docx"
                    #
                    #     s3 = LC::Config::Providers::Aws::S3.new()
                    #     s3_file = s3.get_object(file_path)
                    #     send_data(s3_file["body"].read, filename: file_name, disposition: "inline", stream: "true")
                    def get_object(key)
                        @client.get_object({
                            bucket: self.class.bucket,
                            key: key
                        })
                    end
                    
                    # @param key [String] The object identifier within the bucked
                    # @return [Aws::S3::Types::DeleteObjectOutput] An output stream associated to the deleted S3 object.
                    # @description Connects to Aws and deletes the object associated to the **key** argument.
                    # @example
                    #     file_path = "storage/cloud_house/projects/1/files/112-my-file.docx"
                    #
                    #     s3 = LC::Config::Providers::Aws::S3.new()
                    #     s3.delete_object(file_path)
                    def delete_object(key)
                        @client.delete_object({
                            bucket: self.class.bucket,
                            key: key
                        })
                    end

                    # @param key [String] The object identifier within the bucked
                    # @return [Aws::S3::Types::Object] The created S3 object
                    # @description Connects to Aws and creates a new object with the specified **key** into the 
                    #     bucket
                    # @example
                    #     file_path = "storage/cloud_house/projects/1/files/112-my-file.docx"
                    #
                    #     s3 = LC::Config::Providers::Aws::S3.new()
                    #     s3.create_object(file_path)
                    def create_object(key)
                        @resource.bucket(self.class.bucket).object(key)
                    end

                    # @param key [String] The object identifier within the bucked
                    # @param *expires_in_seconds [Integer] Optional args param. Indicates how many seconds will the url
                    #     remain active. It defaults to 30
                    # @return [String] A URL that allows anyone to access this resource for a limited period of time
                    # @description Uses the credentials stored in Rails.application.credentials.providers[:aws][:s3] to
                    #     generate a temporary link to publicly access the S3 object specifeid by the **key** argument.
                    # @example
                    #     client = LC::Config::Providers::Aws::S3.new()
                    #     object_url = client.generate_object_url("storage/cloud_house/1/files/11-my-file.docx")
                    #     redirect_to object_url
                    def generate_object_url(key, expires_in_seconds: 30)
                        @signer.presigned_url(
                            :get_object,
                            bucket: self.class.bucket,
                            key: key,
                            expires_in: expires_in_seconds
                        )
                    end

                    private

                    def self.bucket
                        bucket = Rails.application.credentials.providers[:aws][:bucket]
                        bucket = Rails.application.credentials.providers[:aws][:s3][:bucket] if Rails.application.credentials.providers[:aws][:s3]
                        bucket
                    end
                end
            end
        end
    end
end
