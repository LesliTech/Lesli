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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Focus
        class Task

            def self.with_deadline(current_user, query)
                return [] unless defined? CloudFocus

                today = Time.now
                filter_year = query[:filters][:year] || today.strftime("%Y")
                filter_month = query[:filters][:month] || today.strftime("%m")
                filter_day = query[:filters][:day]


                tasks = current_user.account.focus.tasks.joins(:detail)
                .select(:id, :title, :description, :deadline)
                .where("cloud_focus_task_details.deadline is not null")
                .where("extract('year' from cloud_focus_task_details.deadline) = ?", filter_year)
                .where("extract('month' from cloud_focus_task_details.deadline) = ?", filter_month)

                tasks = tasks.where("extract('day' from cloud_focus_task_details.deadline) = ?", filter_day) if filter_day
                
                return tasks
            end

            # Returns next due task for a project. Used in summary
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
            
            # This courier method is used mainly by the workflow actions to create tasks from other engines
            def self.tasks_new(current_user, task_params, send_email)
                return unless defined? CloudFocus

                task = CloudFocus::Task.new(task_params)
                task.account = current_user.account.focus
                task.user_creator = current_user
                task.set_workflow
                if task.save!
                    if send_email
                        CloudFocus::Task.send_email_new(task)
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
