=begin

Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

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
