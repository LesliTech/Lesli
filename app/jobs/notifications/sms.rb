module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)

            return unless Rails.env == "production"

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
