=begin

Copyright (c) 2020, all rights reserved.

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

class DeutscheLeibrentenMailer < ApplicationMailer

    # @return [void]
    # @param to [String] The address to which the email will be sent
    # @param subject [String] The subject of the e-mail
    # @param data [Hash] Information to substitute in the template. For this email, the params
    #       :name (the assigned user name), :title (the title of the task), and :href (the path of the task)
    # @description Sends an email informing the assigned user of a new task. The task is an instance of
    # CloudFocus::Task. Important: If the role of the creator is "student", the email must be sent to
    # werksstudenten@deutsche-leibrenten.de. Please check CloudFocus::TasksControler#send_email_notification_new
    # to see that verification
    def generic(to, subject, data, template:"", options: {})
        
        if options.empty?
            options[:template_name] = "generic"
        end

        data[:href] = "#{default_url_options[:host]}#{data[:href]}" if data[:href]

        send(to, subject, data, template: template, options: options)
        
    end

    def kops_order(to, subject, data, template: "", options: {})        
        send2(to, subject, data, template: template, options: options)
    end
end
