module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)
            begin
                # raise error if telephone is nil or empty
                raise ArgumentError.new("telephone number is required, got #{telephone}") if telephone.nil? || telephone.empty?
                raise ArgumentError.new("message is required, got #{message}") if message.nil? || message.empty?


                # regex to verify that telephone is a valid phone number and not contain letters
                phone_with_country_code_regex = /^(\+?)(\d{1,3})?(\s|-)?(\d{3})(\s|-)?(\d{3})(\s|-)?(\d{4})$/
                
                if telephone.match(phone_with_country_code_regex)
                    raise ArgumentError.new("telephone number is invalid, got #{telephone}")
                    return
                end


                unless Rails.application.config.lesli[:configuration][:notifications][:sms]
                    LC::Debug.msg "SMS are deactivated.", telephone, message
                    return
                end

                # verify if telephone has spaces
                if telephone.include? " "
                    telephone_elements = telephone.split(" ")
                    
                    telephone_number = telephone_elements[1]
                    telephone_code = telephone_elements[0]

                    # cast to number telephone_number to remove zero at the beginning
                    telephone_number = telephone_number.to_i

                    telephone = "#{telephone_code} #{telephone_number}"
                end

                LC::Debug.msg "New SMS.", telephone, message if Rails.env == "development"

                sms = LC::Config::Providers::Aws::Sns.new()
                if sms.instance_variable_get(:@client).present?
                    sms.publish(phone_number: telephone, message: message)
                    log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_true", { telephone: telephone })
                end
            rescue => error
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_false", { telephone: telephone })
                LC::Debug.msg error
            end
        end

    end

end
