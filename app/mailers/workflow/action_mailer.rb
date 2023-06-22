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
module Workflow
    class ActionMailer < ApplicationLesliMailer

        def generic
            user = params[:user]
            subject = params[:subject]
            data = params[:data]
            options = params[:options]

            data[:href] = "#{default_url_options[:host]}#{data[:href]}" if data[:href]

            if options[:attachment_files]
                options[:attachment_files].each do |file|
                    if file.attachment && file.attachment_identifier
                        attachments[file.attachment_identifier] = file.attachment.read
                    elsif file.attachment_s3 && file.attachment_s3_identifier
                        attachments[file.attachment_s3_identifier] = file.attachment_s3.read
                    end
                end
            end

            self.build_data_from_params(params, data)

            mail(
                to: email_address_with_name(user["email"], (user["name"] || user["email"])), 
                subject: subject,
                options: options,
                data: data
            )
        end
    end
end
