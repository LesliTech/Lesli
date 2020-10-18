module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)

            # The send of SMS service will be down for a while 
            return

            sms = LC::Config::Providers::Aws::Sns.new()

            begin
                sms.publish(phone_number: telephone, message: message)
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_true", { telephone: telephone })
            rescue => error
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_false", { telephone: telephone })
            end
        end

    end

end
