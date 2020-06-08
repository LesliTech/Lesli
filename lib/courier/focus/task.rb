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

            def self.for(current_user)
            end

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
            
            def self.by_model(model_type, model_id, current_user, query)
                return [] unless defined? CloudFocus
                tasks = current_user.account.focus.tasks
                .select(:id, :title, :description, :deadline, :importance, :task_type, :creator_id, :users_id)
                .select("ua.id as user_id, ua.role as user_role, ua.name as user_value, uc.id as creator_id, uc.role as creator_role, uc.name as creator_value")
                .joins(:detail, :status)
                .joins("inner join users ua on ua.id = cloud_focus_tasks.users_id")
                .joins("inner join users uc on uc.id = cloud_focus_tasks.creator_id")
                .where(
                    "
                        cloud_focus_tasks.model_id = ? AND
                        cloud_focus_tasks.model_type = ? AND
                        cloud_focus_workflow_statuses.completed_successfully != ? AND
                        cloud_focus_workflow_statuses.completed_unsuccessfully != ?
                    ",
                    model_id,
                    model_type,
                    true,
                    true
                )
                .order("#{query[:pagination][:orderColumn]} #{query[:pagination][:order]} NULLS LAST")
                .page(query[:pagination][:page]).per(query[:pagination][:perPage])
                
                tasks_count = tasks.total_count

                tasks = tasks.map do |task|
                    {
                        id: task.id, 
                        title: task.title, 
                        description: task.description,
                        deadline: LC::Date.to_string(task.deadline),
                        deadline_raw: task.deadline,
                        importance: CloudFocus::Task.importances.key(task.importance),
                        task_type: task.task_type,
                        creator: {
                            id: task.creator_id,
                            value: task.creator_value,
                            role: task.creator_role
                        },
                        user: {
                            id: task.user_id,
                            value: task.user_value,
                            role: task.user_role
                        },
                    }
                end
    
                {
                    tasks: tasks,
                    tasks_count: tasks_count
                }
            end

            def self.model_index(current_user, query)
                return [] unless defined? CloudFocus && CloudHouse
                tasks = current_user.account.focus.tasks
                        .select(:id, :title, :description, :deadline, :importance, :task_type, :creator_id, :users_id, :model_id, :model_type)
                        .select("ua.id as user_id, ua.role as user_role, ua.name as user_value, uc.id as creator_id, uc.role as creator_role, uc.name as creator_value")
                        .joins(:status, :detail)
                        .includes(model: [:detail])
                        .where("cloud_focus_workflow_statuses.name = ?", 'created')
                        .joins("inner join users ua on ua.id = cloud_focus_tasks.users_id")
                        .joins("inner join users uc on uc.id = cloud_focus_tasks.creator_id")

                tasks = tasks.where("creator_id = ? or users_id = ?", current_user, current_user) unless query[:filters][:all]
                tasks = tasks.map do |task|

                    model_global_identifier = nil
                    model_global_identifier = task.model.global_identifier if task.model

                    {
                        id: task.id, 
                        title: task.title, 
                        task_type: task.task_type,
                        description: task.description,
                        deadline: LC::Date.to_string(task.deadline),
                        deadline_raw: task.deadline,
                        importance: CloudFocus::Task.importances.key(task.importance),
                        model_type: task.model_type,
                        model_global_identifier: model_global_identifier,
                        creator: {
                            id: task.creator_id,
                            value: task.creator_value,
                            role: task.creator_role
                        },
                        user: {
                            id: task.user_id,
                            value: task.user_value,
                            role: task.user_role
                        },
                        details: task.model.detail
                    }
                end
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
                .where("cloud_focus_workflow_statuses.completed_successfully != ?", true)
                .where("cloud_focus_workflow_statuses.completed_unsuccessfully != ?", true)
                .order("cloud_focus_task_details.deadline asc")
                .first

                if next_task
                    return next_task[:deadline]
                end

                return nil
            end

            # This courier method is used mainly by the workflow actions to create tasks from other engines
            def self.tasks_new(current_user, task_params, send_email)
                return unless defined? CloudFocus

                task = CloudFocus::Task.new(task_params)
                task.account = current_user.account.focus
                task.creator = current_user
                task.set_workflow
                if task.save!
                    if send_email
                        CloudFocus::Task.send_email_new(task)
                    end
                    CloudFocus::Task.log_activity_create(current_user, task)
                    CloudFocus::Task.send_notification_new(task)
                end

                task
            end
        end
    end
end
