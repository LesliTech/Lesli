class Files::S3UploaderJob < ApplicationJob
    queue_as :default

    def perform(file)
        s3 = LC::Storage.create_object(file.attachment.url[1..-1])

        s3.put(
            body: file.attachment.read, 
            acl: "private"
        ) 

        puts "HERE I SHOULD CHANGE THE LOCATION OF THE FILE"
    end
end
