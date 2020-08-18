class SystemActivity < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"

    require 'aws-sdk-s3'
    

    def self.log_email(system_module, description)

        s3_resource = Aws::S3::Resource.new(
            region: Rails.application.credentials.s3[:region],
            access_key_id: Rails.application.credentials.s3[:access_key_id], 
            secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
        )

        file_name = "#{LC::Date.now.strftime("%d_%m_%y_%H:%M")}_#{description[:subject]}".gsub(/\s+/, "_") 
        s3_bucket = s3_resource.bucket(Rails.application.credentials.s3[:bucket])
        s3_object = s3_bucket.object("system_activities/emails/#{system_module}/#{file_name}.html")
        
        s3_object.put(
            body: description[:body], 
            content_type: "text/html",
            acl: "private"
        )

        Account.first.system_activities.create(
            system_module: system_module,
            system_process: "mailer",
            description: {
                subject: description[:subject],
                s3_key: s3_object.key,
                to: description[:to]
            }
        )
    end
end
