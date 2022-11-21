module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)
            begin

                unless Rails.application.config.lesli[:configuration][:notifications][:sms]
                    LC::Debug.msg "SMS are deactivated.", telephone, message
                    return
                end

                LC::Debug.msg "New SMS.", telephone, message if Rails.env == "development"

                validated_data = Notifications::Sms.validate(telephone, message)

                sms = LC::Config::Providers::Aws::Sns.new()

                if sms.instance_variable_get(:@client).present?
                    sms.publish(phone_number: validated_data[:telephone], message: validated_data[:message])
                    log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_true", { telephone: telephone })
                end
            rescue => error
                log_account_activity("Lesli", "app/jobs/notifications/sms", "sms_send_false", { telephone: telephone })
                LC::Debug.msg error
            end
        end


        def self.validate(telephone, message)

            # strip telephone number only at the beginning and end
            telephone = telephone.strip if telephone.present?
            message = message.strip if message.present?

            # raise error if telephone is nil or empty
            raise ArgumentError.new("telephone number is invalid, got #{telephone}") if telephone.nil? || telephone.empty?
            raise ArgumentError.new("message is invalid, got #{message}") if message.nil? || message.empty? || message.length > 100
            

            # regex to verify that telephone is a valid phone number and not contain letters
            phone_with_country_code_regex = /^(\+)(\d{1,3})(\s|-)(\d{4,10})$/
            
            match_groups = telephone.match(phone_with_country_code_regex)

            unless telephone.match(phone_with_country_code_regex)
                raise ArgumentError.new("telephone number is invalid, got #{telephone}")
                return
            end

            # verify if telephone has spaces
            
            telephone_elements = telephone.split(" ")
            
            telephone_number = telephone_elements[1]
            telephone_code = telephone_elements[0]

            # cast to number telephone_number to remove zero at the beginning
            telephone_number = telephone_number.to_i

            telephone = "#{telephone_code} #{telephone_number}"
            

            {
                telephone: telephone,
                message: message
            }
        end

    end

end
