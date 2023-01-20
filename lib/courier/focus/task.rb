=begin

Copyright (c) 2023, all rights reserved.

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

module Courier
    module Focus
        class Task

            def self.count(current_user)
                return 0 unless defined? CloudFocus
                CloudFocus::Task.count(current_user)
            end

            def self.with_deadline(current_user, query)
                return [] unless defined? CloudFocus
                CloudFocus::Task.with_deadline(current_user, query)
            end

            # Returns next due task for a project. Used in deutsche_leibrenten/summary
            def self.find_next_task_due(current_user, project)
                return nil unless defined? CloudFocus && CloudHouse

                next_task = current_user.account.focus.tasks
                .joins(:status)
                .joins(:detail)
                .select("cloud_focus_task_details.deadline")
                .where("cloud_focus_tasks.model_type = ?", "CloudHouse::Project")
                .where("cloud_focus_tasks.model_id = ?", project.id)
                .where("cloud_focus_workflow_statuses.status_type not in (?)", ["completed_successfully", "completed_unsuccessfully", "to_be_deleted"])
                .order("cloud_focus_task_details.deadline asc")
                .first

                if next_task
                    return next_task[:deadline]
                end

                return nil
            end

            def self.index(current_user, query)
                return [] unless defined? CloudFocus
                CloudFocus::Task.index(current_user, query)
            end

            def self.show(current_user, query, task_id)
                return [] unless defined? CloudFocus
                task = current_user.account.focus.tasks.find_by_id(task_id)
                task.show(current_user) if task
            end

            def self.create(current_user, task_params)
                return nil unless defined? CloudFocus
                CloudFocus::TaskService.create(current_user: current_user, task_params: task_params)
            end

            def self.options(current_user, query)
                return {} unless defined? CloudFocus
                CloudFocus::Task.options(current_user, query)
            end

            def self.update(current_user, task_id, task_params)
                return {} unless defined? CloudFocus
                task = current_user.account.focus.tasks.find_by_id(task_id)
                CloudFocus::TaskService.update(current_user, task, task_params)
            end

            def self.destroy(current_user, task_id)
                return nil unless defined? CloudFocus
                task = current_user.account.focus.tasks.find_by_id(task_id)
                CloudFocus::TaskService.destroy(current_user, task)
            end

            # This courier method is used mainly by the workflow actions to create tasks from other engines
            def self.tasks_new(current_user, task_params, send_email)
                return unless defined? CloudFocus

                task = CloudFocus::Task.new(task_params)
                task.account = current_user.account.focus
                task.user_creator = current_user
                task.set_workflow
                if task.save!
                    if send_email
                        CloudFocus::TaskService.send_email_for_new_task(task)
                    else
                        CloudFocus::Task.send_notification_new(task)
                    end
                    CloudFocus::Task.log_activity_create(current_user, task)
                end

                task
            end
        end
    end
end
