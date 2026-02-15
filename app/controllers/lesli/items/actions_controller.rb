=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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
    module Items
        class ActionsController < ApplicationLesliController
            before_action :set_action, only: [:create, :update]

            def create 
                action = @parent_resource.actions.new({
                    title: action_params['title'],
                    done: action_params['done'] || false,
                    user_id: current_user.id
                })

                if action.save
                    respond_with_lesli(:turbo => [
                        stream_notification_success("Action created"),
                        stream_actions_component()
                    ])
                else
                    respond_with_lesli(
                        :turbo => stream_notification_danger(action.errors.full_messages)
                    )
                end
            end

            def update 

                @resource.done = true
                @resource.save

                respond_with_lesli(:turbo => [
                    stream_notification_success("Action updated"),
                    stream_actions_component()
                ])
            end 

            private 

            def stream_actions_component
                turbo_stream.update("#{@action_parent_object}-actions") do 
                    LesliView::Items::Actions.new(
                        @parent_resource, 
                        path_to_create:public_send(@action_path_string, @parent_resource),
                        path_to_update:->(action) {
                            public_send(@action_update_path_string, @parent_resource, action)
                        }
                    ).render_in(view_context)
                end
            end

            def set_action

                # Get the item model class, example: LesliSupport::Ticket::Discussion
                @action_model = self.class.name.gsub("Controller","").singularize.constantize

                # Get the parent model class, example: LesliSupport::Ticket
                @action_model_parent = @action_model.reflect_on_association(:item).klass

                # Get the row owner name, example: from LesliSupport::Ticket gets ticket
                @action_parent_object = "#{@action_model_parent.name.demodulize.underscore}"

                # Get the parent associations id, example: ticket_id
                @action_model_parent_id = "#{@action_parent_object}_id"

                # Get the local path method, example: ticket_discussions_path
                @action_path_string = "#{@action_parent_object}_actions_path"

                # Get the local path method, example: ticket_discussion_path
                @action_update_path_string = "#{@action_parent_object}_action_path"

                # Get the parent resource
                @parent_resource = @action_model_parent.find_by_id(
                    params[@action_model_parent_id.to_sym]
                )

                @resource = @parent_resource.actions.find(params[:id]) if params[:id]

            end

            def action_params
                # Get the params key, example: ticket_action
                action_model_param_key = @action_model.model_name.param_key
                params.require(action_model_param_key.to_sym).permit(
                    :title,
                    :done,
                    @action_model_parent_id
                )
            end
        end
    end
end
