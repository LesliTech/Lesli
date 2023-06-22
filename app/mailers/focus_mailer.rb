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
class FocusMailer < ApplicationLesliMailer
    # @return [void]
    # @param user [User] User assigned to the task
    # @param task [CloudFocus::Task] The new task created
    # @description Sends an email informing the assigned user of a new task.
    def task_new
        user = params[:user]
        task = params[:task]

        # By default it is the CloudFocus path but you can change the url as for example "crm/task".
        url = "#{CloudFocus::Engine.routes.url_helpers.tasks_path}/#{task.id}"
        url = params[:url] if params[:url].present?

        # By default the recipients is the assigned user but you can customize by sending to a specific email.
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
