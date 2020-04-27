class TasksNewJob < ApplicationJob
    queue_as :default

    def perform(current_user, task_params, send_email)
        task = CloudFocus::Task.new(task_params)
        task.account = current_user.account.focus
        task.creator = current_user
        task.set_workflow
        if task.save 
            if send_email
                CloudFocus::Task.send_email_new(task)
            end
        end
    end
end
