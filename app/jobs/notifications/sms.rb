module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)

            if not Rails.application.config.lesli["configuration"]["notifications"]["sms"]
                LC::Debug.msg "SMS are deactivated.", telephone, message
                return
            end

            LC::Debug.msg "New SMS.", telephone, message if Rails.env == "development"

            sms = LC::Config::Providers::Aws::Sns.new()

            begin
                sms.publish(phone_number: telephone, message: message)
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_true", { telephone: telephone })
            rescue => error
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_false", { telephone: telephone })
                LC::Debug.msg error
            end
        end

    end

end
