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

            def self.with_deadline(current_user)
                return [] unless defined? CloudFocus
                current_user.account.focus.tasks.joins(:detail)
                .select(:id, :title, :description, :deadline)
                .where("cloud_focus_task_details.deadline is not null")
                .where("date_trunc('month', cloud_focus_task_details.deadline) = date_trunc('month', CURRENT_DATE)")
                .limit(100)
            end

            def self.with_deadline_date(current_user, date, query)
                return [] unless defined? CloudFocus
                current_user.account.focus.tasks.joins(:detail)
                .select(:id, :title, :description, :deadline)
                .where("cloud_focus_task_details.deadline = ?", date)
                .limit(100)
            end
            
            def self.by_model(model_type, model_id, current_user, query)
                return [] unless defined? CloudFocus
                tasks = current_user.account.focus.tasks
                .select(:id, :title, :description, :deadline, :importance, :task_type, :creator_id, :users_id)
                .joins(:detail, :status)
                .where("cloud_focus_tasks.model_id = ? AND cloud_focus_tasks.model_type = ? AND cloud_focus_workflow_statuses.name = ? ", model_id, model_type, 'created')
                .order("cloud_focus_tasks.created_at")
                .page(query[:pagination][:page]).per(query[:pagination][:perPage])

                tasks_count = tasks.total_count

                tasks = tasks.map do |task|
                    {
                        id: task.id, 
                        title: task.title, 
                        description: task.description,
                        deadline: CloudHelper::Date.date_as_string(task.deadline),
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

                tasks = CloudFocus::Task
                        .select(:id, :title, :description, :deadline, :importance, :task_type, :creator_id, :users_id, :model_id, :model_type)
                        .joins(:status, :detail)
                        .includes(:model)
                        .where("cloud_focus_tasks.accounts_id = ? AND cloud_focus_workflow_statuses.name = ?", current_user.account.id, 'created')
                        .page(query[:pagination][:page]).per(query[:pagination][:perPage])
                
                tasks_count = tasks.total_count

                tasks = tasks.map do |task|

                    {
                        id: task.id, 
                        title: task.title, 
                        description: task.description,
                        deadline: CloudHelper::Date.date_as_string(task.deadline),
                        importance: task.importance,
                        creator: Courier::Core::Users.get(task.creator_id),
                        user: Courier::Core::Users.get(task.users_id),
                        model_detail: (task.model_type == "CloudHouse::Project") ? task.model.detail.code : task.model.detail.name
                    }
                end
                
                {
                    tasks: tasks,
                    tasks_count: tasks_count
                }
            end

            def self.concerns_options(current_user)
                return [] unless defined? CloudHouse
                    concerns_companies = current_user.account.house.companies
                                .select("cloud_house_companies.id, cloud_house_company_details.name as text")
                                .joins(:detail)

                    concerns_projects = current_user.account.house.projects
                        .select("cloud_house_projects.id, concat(CHPRD.city, ' - ', CHCD.last_name, '', CHCD.first_name) as text")
                        .joins("inner join cloud_house_project_customers CHPC on CHPC.cloud_house_projects_id = cloud_house_projects.id")
                        .joins("inner join cloud_house_contacts CHC on CHC.id = CHPC.cloud_house_contacts_id")
                        .joins("inner join cloud_house_contact_details CHCD on CHC.id = CHCD.cloud_house_contacts_id")
                        .joins("inner join cloud_house_properties CHPR on CHPR.id = cloud_house_projects.cloud_house_properties_id")
                        .joins("inner join cloud_house_property_details CHPRD on CHPR.id = CHPRD.cloud_house_properties_id")
                        .joins("inner join cloud_house_workflow_statuses CHWS on CHWS.id = cloud_house_projects.cloud_house_workflow_statuses_id")
                        .where("CHWS.name != ? AND CHWS.name != ? AND CHWS.name != ?", 'not_interested', 'customer_has_rejected', 'customer_was_rejected')
                
                {
                    companies: concerns_companies,
                    projects: concerns_projects
                }
            end
        end
    end
end
