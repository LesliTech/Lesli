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

        url = "#{CloudFocus::Engine.routes.url_helpers.tasks_path}/#{task.id}"
        url = params[:url] if params[:url].present?

        receipts = task.user_main.email
        receipts = params[:receipts] if params[:receipts].present?

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
            to: receipts,
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

    def task_report_delayed
        users_and_tasks = params[:users_and_tasks]
        receipts = params[:receipts]

        build_data_from_params(params, {
            users_and_tasks: users_and_tasks
        })

        mail(
            to: receipts,
            subject: I18n.t("focus.tasks.mailer_task_report_deplayed_subject")
        )
    end

end
