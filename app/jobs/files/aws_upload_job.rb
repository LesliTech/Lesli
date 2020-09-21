class Files::AwsUploadJob < ApplicationJob
    queue_as :default

    def perform(file)
        if file.attachment_local.file && !file.attachment.file
            file.update!(attachment: file.attachment_local)
            file.update!(attachment_local: nil)

            # Sanity check in case the file got deleted when uploading it to AWS
            # We reload the ActiveRecord because the one received as parameter is not up to date
            file.update!(attachment: nil) unless file.class.find_by(id: file.id)
        end
    end
end
