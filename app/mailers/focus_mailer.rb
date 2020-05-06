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
    def task_new(to, subject, data, template:"")
        data = data.merge({
            href: "#{default_url_options[:host]}#{data[:href]}"
        })

        send(to, subject, data, template:"")
        
    end

    def task_list(to, subject, data, template: "")
        data[:tasks] = data[:tasks].map do |task|
            task[:href] = "#{default_url_options[:host]}#{task[:href]}"
            task
        end

        send(to, subject, data, template:"")
    end

    def task_report_delayed(data, template: "")
        to = ["m.auel@deutsche-leibrenten.de","b.norgiev@deutsche-leibrenten.de"]
        subject = "Due workflows / tasks"

        data[:users].each do |user|
            user[:tasks] = user[:tasks].map do |task|
                task[:href] = "#{default_url_options[:host]}#{task[:href]}"
                task
            end
        end
        
        send(to, subject, data, template:"")
    end

end
