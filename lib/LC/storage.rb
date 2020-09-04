module LC
    class Storage
        def self.get_object(path)
            return( 
                Aws::S3::Client.new(
                    region: Rails.application.credentials.s3[:region],
                    access_key_id: Rails.application.credentials.s3[:access_key_id], 
                    secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
                ).get_object(
                    bucket: Rails.application.credentials.s3[:bucket],
                    key: path
                )
            )
        end

        def self.delete_object(path)
            return (
                Aws::S3::Client.new(
                region: Rails.application.credentials.s3[:region],
                access_key_id: Rails.application.credentials.s3[:access_key_id], 
                secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
                ).delete_object(
                    bucket: Rails.application.credentials.s3[:bucket],
                    key: path
                )
            )
        end

        def self.create_object(path)
            return ( 
                Aws::S3::Resource.new(
                    region: Rails.application.credentials.s3[:region],
                    access_key_id: Rails.application.credentials.s3[:access_key_id], 
                    secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
                )
                .bucket(Rails.application.credentials.s3[:bucket])
                .object(path)
            )
        end
    end
end