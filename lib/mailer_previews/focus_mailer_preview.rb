
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
