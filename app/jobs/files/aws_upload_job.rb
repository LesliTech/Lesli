class Files::AwsUploadJob < ApplicationJob
    queue_as :default

    def perform(file)
        begin
            if file.public
                if file.attachment.file && (!file.attachment_public.file || (file.attachment_public_identifier != file.attachment_identifier))
                    file.update!(attachment_public: file.attachment)

                    if file.attachment_public
                        file.update!(attachment: nil)

                        # Sanity check in case the file got deleted when uploading it to AWS
                        # We reload the ActiveRecord because the one received as parameter is not up to date
                        file.update!(attachment_public: nil) unless file.class.find_by(id: file.id)
                    end
                end
            else
                if file.attachment.file && (!file.attachment_s3.file || (file.attachment_s3_identifier != file.attachment_identifier))
                    file.update!(attachment_s3: file.attachment)

                    if file.attachment_s3
                        file.update!(attachment: nil)

                        # Sanity check in case the file got deleted when uploading it to AWS
                        # We reload the ActiveRecord because the one received as parameter is not up to date
                        file.update!(attachment_s3: nil) unless file.class.find_by(id: file.id)
                    end
                end
            end
        rescue => error
            file.cloud_object.account.account.activities.create({
                system_module: file.class.name.split("::")[0],
                system_process: "aws_uploader",
                payload: error.to_json
            })
        end
    end
end
