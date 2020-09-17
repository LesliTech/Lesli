module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def self.send(user, message, request_method, request_controller)
            sms = Aws::SNS::Client.new(
                region: Rails.application.credentials.services[:aws][:region],
                access_key_id: Rails.application.credentials.services[:aws][:access_key_id],
                secret_access_key: Rails.application.credentials.services[:aws][:secret_access_key],
            ).publish(
                phone_number: user.detail.telephone,
                message: message
            )

            user.log_activity(request_method, request_controller, nil, nil, 'Token sent successfully')

            sms
        end

    end

end
