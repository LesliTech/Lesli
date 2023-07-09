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

class FocusMailerPreview < ActionMailer::Preview
    def task_new
        task = CloudFocus::Task.first
        url = "#{CloudFocus::Engine.routes.url_helpers.tasks_path}/#{task.id}"
        FocusMailer.with(
            user: User.first,
            task: task,
            url: url,
            receipt: User.first.email
        ).task_new
    end

    def task_list
        tasks = CloudFocus::Task.all.map do |task|
            {
                title: task.detail.title,
                deadline: LC::Date.to_string(task.detail.deadline),
                creator: task.user_main.detail.first_name,
                model_type: task.model_type,
                importance: "importance",
                href: "#{CloudFocus::Engine.routes.url_helpers.tasks_path}/#{task.id}"
            }
        end
        FocusMailer.with(user: User.first, tasks: tasks).task_list
    end

    def task_report_delayed
        user_main_name = User.first.detail.first_name
        data = []
        tasks = CloudFocus::Task.all.map do |task|
            {
                title: task.detail.title,
                deadline: LC::Date.to_string(task.detail.deadline),
                creator: task.user_main.detail.first_name,
                model_type: task.model_type,
                importance: "importancia",
                href: "#{CloudFocus::Engine.routes.url_helpers.tasks_path}/#{task.id}"
            }
        end
        data.push({ name: user_main_name, tasks: tasks })
        ::FocusMailer.with(users_and_tasks: data, receipts: User.first.email).task_report_delayed.deliver_now
    end
end
