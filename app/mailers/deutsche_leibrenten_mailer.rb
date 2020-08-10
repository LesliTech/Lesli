=begin
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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

    def leads_report(to, subject, data, template: "")        
        send(to, subject, data, template:"")
    end

    def kops_order(to, subject, data, template: "")        
        send(to, subject, data, template:"")
    end
end
