module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)

            sms = Aws::SNS::Client.new(
                region: Rails.application.credentials.services[:aws][:region],
                access_key_id: Rails.application.credentials.services[:aws][:access_key_id],
                secret_access_key: Rails.application.credentials.services[:aws][:secret_access_key],
            )

            begin
                sms.publish(phone_number: telephone, message: message)
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_true", { telephone: telephone })
            rescue => error
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_false", { telephone: telephone })
            end

        end

    end

end
