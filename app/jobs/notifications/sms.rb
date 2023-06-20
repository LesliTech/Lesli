=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

module Notifications

    class Sms < ApplicationJob
        queue_as :default

        def perform(telephone, message)
            begin

                unless Rails.application.config.lesli.dig(:configuration, :notifications, :sms)
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
            phone_with_country_code_regex = /^(\+)(1[ \-\+]{0,3}|\+1[ -\+]{0,3}|\+1|\+)?((\(\+?1-[2-9][0-9]{1,2}\))|(\(\+?[2-8][0-9][0-9]\))|(\(\+?[1-9][0-9]\))|(\(\+?[17]\))|(\([2-9][2-9]\))|([ \-\.]{0,3}[0-9]{2,4}))?([ \-\.][0-9])?([ \-\.]{0,3}[0-9]{2,4}){2,3}$/

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
