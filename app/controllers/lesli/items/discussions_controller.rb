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
        class DiscussionsController < ApplicationLesliController
            before_action :set_discussion, only: [:create]

            def create 
                discussion = @parent_resource.discussions.new({
                    message: discussion_params[:message],
                    user_id: current_user.id
                })

                discussion_saved = discussion.save
                respond_to do |format|
                    format.html 
                    #format.turbo_stream
                    format.turbo_stream do 
                        if discussion_saved
                            respond_with_stream(
                                stream_notification_success("Comment created"),
                                turbo_stream.update("#{@discussion_parent_object}-discussions") do 
                                    LesliView::Items::Discussions.new(@parent_resource, public_send(@discussion_path_string, @parent_resource)).render_in(view_context)
                                end
                            )
                        else 
                            respond_with_stream(stream_notification_danger(discussion.errors.full_messages))
                        end
                    end
                end
            end

            private 

            def set_discussion

                # Get the item model class, example: LesliSupport::Ticket::Discussion
                @discussion_model = self.class.name.gsub("Controller","").singularize.constantize

                # Get the parent model class, example: LesliSupport::Ticket
                @discussion_model_parent = @discussion_model.reflect_on_association(:item).klass

                # Get the row owner name, example: from LesliSupport::Ticket gets ticket
                @discussion_parent_object = "#{@discussion_model_parent.name.demodulize.underscore}"

                # Get the parent associations id, example: ticket_id
                @discussion_model_parent_id = "#{@discussion_parent_object}_id"

                # Get the local path method, example: ticket_discussions_path
                @discussion_path_string = "#{@discussion_parent_object}_discussions_path"

                # Get the parent resource
                @parent_resource = @discussion_model_parent.find_by_id(
                    params[@discussion_model_parent_id.to_sym]
                )
            end

            def discussion_params
                # Get the params key, example: ticket_discussion
                discussion_model_param_key = @discussion_model.model_name.param_key
                params.require(discussion_model_param_key.to_sym).permit(
                    :message,
                    @discussion_model_parent_id
                )
            end
        end
    end
end
