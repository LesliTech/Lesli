module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)

            sms = LC::Providers::Aws::Sns.new()
            sms.publish({
                phone_number: user.detail.telephone,
                message: message
            })

            begin
                sms.publish(phone_number: telephone, message: message)
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_true", { telephone: telephone })
            rescue => error
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_false", { telephone: telephone })
            end
        end

    end

end
