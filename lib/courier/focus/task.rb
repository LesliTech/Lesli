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
                filter_date = query[:filters][:date]


                tasks = current_user.account.focus.tasks.joins(:detail)
                .select(:id, :title, :description, :deadline)
                .where("cloud_focus_task_details.deadline is not null")

                if filter_date
                    tasks = taks.where("cloud_focus_tasks.deadline = ?", filter_date)
                else
                    tasks = tasks.where(
                        "extract('year' from cloud_focus_task_details.deadline) = ?", filter_year
                    ).where(
                        "extract('month' from cloud_focus_task_details.deadline) = ?", filter_month
                    )
                end
            end
            
            def self.by_model(model_type, model_id, current_user, query)
                return [] unless defined? CloudFocus
                tasks = current_user.account.focus.tasks
                .select(:id, :title, :description, :deadline, :importance, :task_type, :creator_id, :users_id)
                .joins(:detail, :status)
                .where("cloud_focus_tasks.model_id = ? AND cloud_focus_tasks.model_type = ? AND cloud_focus_workflow_statuses.name != ? ", model_id, model_type, 'done')
                .order("cloud_focus_tasks.created_at")
                .page(query[:pagination][:page]).per(query[:pagination][:perPage])
                
                tasks_count = tasks.total_count

                tasks = tasks.map do |task|
                    {
                        id: task.id, 
                        title: task.title, 
                        description: task.description,
                        deadline: Courier::Core::Date.to_string(task.deadline, "%d.%m.%Y"),
                        importance: task.importance,
                        task_type: task.task_type,
                        creator: Courier::Core::Users.get(task.creator_id),
                        user: Courier::Core::Users.get(task.users_id)
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
                        .joins(:status, :detail)
                        .includes(model: [:detail])
                        .where("cloud_focus_workflow_statuses.name = ?", 'created')
                
                tasks = tasks.where(creator: current_user) unless query[:filters][:all]
                
                if defined? (CloudLock)
                    tasks = tasks.select("ua.id as user_id, concat(uda.first_name,' ', uda.last_name) as user_value, 
                                uc.id as creator_id, uc.concat(udc.first_name,' ', udc.last_name) as creator_value")
                                .joins("inner join users ua on ua.id = cloud_focus_tasks.users_id")
                                .joins("inner join users uc on uc.id = cloud_focus_tasks.creator_id")
                                .joins("inner join user_details uda on ud.id = ua.id")
                                .joins("inner join user_details udc on ud.id = uc.id")
                else
                    tasks = tasks.select("ua.id as user_id, ua.email as user_value, uc.id as creator_id, uc.email as creator_value")
                                .joins("inner join users ua on ua.id = cloud_focus_tasks.users_id")
                                .joins("inner join users uc on uc.id = cloud_focus_tasks.creator_id")
                end
                
                tasks = tasks.map do |task|

                    {
                        id: task.id, 
                        title: task.title, 
                        description: task.description,
                        deadline: Courier::Core::Date.to_string(task.deadline, "%d.%m.%Y"),
                        importance: task.importance,
                        model_type: task.model_type,
                        creator: {
                            id: task.creator_id,
                            value: task.creator_value
                        },
                        user: {
                            id: task.user_id,
                            value: task.user_value
                        },
                        details: task.model.detail
                    }
                end
            end
        end
    end
end
