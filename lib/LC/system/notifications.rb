module LC

    module System

        class Notifications

            def self.send_sms(telephone, message)
                return(
                    Aws::SNS::Client.new(
                        region: Rails.application.credentials.services[:aws][:region],
                        access_key_id: Rails.application.credentials.services[:aws][:access_key_id],
                        secret_access_key: Rails.application.credentials.services[:aws][:secret_access_key],
                    ).publish(
                        phone_number: telephone,
                        message: message
                    )
                )
            end

        end

    end

end
