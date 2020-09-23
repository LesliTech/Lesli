module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def self.send(user, message, request_method, request_controller)
            sms = LC::Providers::Aws::Sns.new()

            sms.publish({
                phone_number: user.detail.telephone,
                message: message
            })

            begin
                sms.publish(
                    phone_number: user.detail.telephone,
                    message: message
                )
            rescue => error
                puts "Failed SMS send"
            end

            user.log_activity(request_method, request_controller, nil, nil, 'Token sent successfully')

            sms
        end

    end

end
