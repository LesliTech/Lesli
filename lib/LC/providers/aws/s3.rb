module LC::Providers::Aws
    class S3
        def initialize
            @client = Aws::S3::Client.new()
            @resource = Aws::S3::Resource.new()



            if Rails.application.credentials.providers[:aws][:s3]
                s3_credentials = {
                    region: Rails.application.credentials.providers[:aws][:s3][:region],
                    access_key_id: Rails.application.credentials.providers[:aws][:s3][:access_key_id],
                    secret_access_key: Rails.application.credentials.providers[:aws][:s3][:secret_access_key]
                }

                @client = Aws::S3::Client.new(s3_credentials)
                @resource = Aws::S3::Resource.new(s3_credentials)

                self
            end
        end

        def get_object(key)
            @client.get_object({
                bucket: self.class.bucket,
                key: key
            })
        end
        
        def delete_object(key)
            @client.delete_object({
                bucket: self.class.bucket,
                key: key
            })
        end

        def create_object(key)
            @resource.bucket(self.class.bucket).object(key)
        end

        private

        def self.bucket
            bucket = Rails.application.credentials.providers[:aws][:bucket]
            bucket = Rails.application.credentials.providers[:aws][:s3][:bucket] if Rails.application.credentials.providers[:aws][:s3]
            bucket
        end
    end
end
