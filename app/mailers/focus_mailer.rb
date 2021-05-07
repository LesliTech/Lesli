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
class FocusMailer < ApplicationLesliMailer
    def task_new
        user = params[:user]
        task = params[:task]
        url = params[:url]
        receipt = params[:receipt]

        build_data_from_params(params, {
            url: url,
            user: {
                full_name: user.full_name
            },
            task: {
                title: task.detail.title
            }
        })
        mail(
            to: receipt,
            subject: I18n.t("focus.tasks.mailer_new_task_subject")
        )
    end

    def task_list
        tasks = params[:tasks]
        user = params[:user]

        build_data_from_params(params, {
            user: {
                full_name: user.full_name
            },
            tasks: tasks
        })

        mail(
            to: email_address_with_name(user.email, user.full_name),
            subject: I18n.t("focus.tasks.mailer_task_remainder_subject")
        )
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
        
        send2(to, subject, data, template: template, options: options)
    end

end
