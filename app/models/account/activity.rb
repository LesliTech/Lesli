class Account::Activity < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"

    require 'aws-sdk-s3'

    def log_activity(system_module, system_process, description=nil)
        self.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description
        })
    end
    
    def self.log_email(system_module, description)

        activity = Account.first.activities.create(
            system_module: system_module,
            system_process: "mailer",
        )

        file_name = "#{activity.id}_#{LC::Date.now.strftime("%d-%m-%y-%H:%M")}#{description[:subject].present? ? "_#{description[:subject]}" : ""}".gsub(/\s+/, "_") 

        s3 = LC::Providers::Aws::S3.new()
        s3_object = s3.create_object("system_activities/emails/#{system_module}/#{file_name}.html")
        s3_object.put(
            body: description[:body], 
            content_type: "text/html",
            acl: "private"
        )
        
        activity.update(payload: {
                subject: description[:subject],
                s3_key: s3_object.key,
                to: description[:to]
            }
        )
    end
end
