=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    module Item
        class TasksController < ApplicationLesliController
            before_action :set_task, only: %i[show update]
            before_action :set_taskable, only: %i[index create]

            def index
                @tasks = task_class
                    .where(account: current_user.account)
                    .order(created_at: :desc)
                respond_with_lesli(json: @tasks)
            end

            def show
            end

            def create
                task = task_class.new(task_params)

                task.user = current_user
                task.account = current_user.account
                task.taskable = @taskable if @taskable

                if task.save
                    respond_with_lesli(:turbo => [
                        stream_notification_success("Task created"),
                        turbo_stream.prepend("#{scope_key}-lesli-items-tasks-list") do
                            LesliView::Item::Task.new(task, scope_key).render_in(view_context)
                        end
                    ])
                else
                    respond_with_lesli(
                        :turbo => stream_notification_danger(task.errors.full_messages)
                    )
                end
            end

            def update
                @task.done = true
                @task.save
                respond_with_lesli(:turbo => [
                    stream_notification_success("Task updated #{@taskable}"),
                    turbo_stream.replace(helpers.dom_id(@task, scope_key)) do 
                        LesliView::Item::Task.new(@task, scope_key).render_in(view_context)
                    end
                ])
            end

            private

            # return a key to identify the engine where the tasks are running
            def scope_key = ActiveSupport::Inflector.underscore(task_class.name).tr("/", "_")

            # return the task class including the engine where the tasks are running
            def task_class = self.class.module_parent.const_get("Task")

            # validate we invoke only models that implements Lesli::Item::Tasks concern
            def validate_taskable taskable

                # 1. Attempt to resolve the class safely
                klass = taskable.safe_constantize

                # 2. VALIDATION: Check if the class is allowed to be taskable
                # We check if the class exists AND if it includes your specific taskable trait
                unless klass && klass.respond_to?(:is_lesli_taskable?) && klass.is_lesli_taskable?
                    render json: { error: "Unauthorized taskable type" }, status: :forbidden and return
                end

                klass
            end

            def set_task
                @task = task_class.where(account: current_user.account).find(params[:id])
            end

            # Permite filtrar/crear para un actionable específico:
            # params: actionable_type=LesliSupport::Ticket&actionable_id=123
            def set_taskable
                type = params[:taskable_type].presence
                id   = params[:taskable_id].presence
                return if type.blank? || id.blank?

                taskable = validate_taskable(type)

                # 3. Execution: Now it is safe to query
                @taskable = taskable.where(account: current_user.account).find_by(id: id)
            end

            def task_params
                params.require(scope_key.to_sym).permit(:title)
            end
        end
    end
end
