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

class FocusMailer < ApplicationMailer

    # @return [void]
    # @param to [String] The address to which the email will be sent
    # @param subject [String] The subject of the e-mail
    # @param data [Hash] Information to substitute in the template. For this email, the params
    #       :name (the assigned user name), :title (the title of the task), and :href (the path of the task)
    # @description Sends an email informing the assigned user of a new task. The task is an instance of
    # CloudFocus::Task. Important: If the role of the creator is "student", the email must be sent to
    # werksstudenten@deutsche-leibrenten.de. Please check CloudFocus::TasksControler#send_email_notification_new
    # to see that verification
    def task_new(to, subject, data, template:"", options:{})
        data = data.merge({
            href: "#{default_url_options[:host]}#{data[:href]}"
        })

        send(to, subject, data, template: template, options: options)
        
    end

    def task_list(to, subject, data, template:"", options:{})
        data[:tasks] = data[:tasks].map do |task|
            task[:href] = "#{default_url_options[:host]}#{task[:href]}"
            task
        end

        send(to, subject, data, template: template, options: options)
    end

    def task_report_delayed(data, template:"", options:{})
        to = ["m.auel@deutsche-leibrenten.de","b.norgiev@deutsche-leibrenten.de"]
        subject = I18n.t("deutscheleibrenten.tasks.email_subject_report_delayed_tasks")

        data[:users].each do |user|
            user[:tasks] = user[:tasks].map do |task|
                task[:href] = "#{default_url_options[:host]}#{task[:href]}"
                task
            end
        end
        
        send(to, subject, data, template: template, options: options)
    end

end
