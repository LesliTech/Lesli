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
    module Items
        class DiscussionsController < ApplicationLesliController
            before_action :set_discussion, only: %i[show update]
            before_action :set_discussable, only: %i[index create]

            def index
                @discussions = discussion_class
                    .where(account: current_user.account)
                    .order(created_at: :desc)
                respond_with_lesli(json: @discussions)
            end

            def show
            end

            def create
                discussion = discussion_class.new(discussion_params)

                discussion.user = current_user
                discussion.account = current_user.account
                discussion.discussable = @discussable if @discussable

                if discussion.save
                    respond_with_lesli(:turbo => [
                        stream_notification_success("Discussion created"),
                        turbo_stream.prepend("#{scope_key}-lesli-items-discussions-list") do
                            LesliView::Items::Discussion.new(discussion).render_in(view_context)
                        end
                    ])
                else
                    respond_with_lesli(
                        :turbo => stream_notification_danger(discussion.errors.full_messages)
                    )
                end
            end

            def update
                @discussion.done = true
                @discussion.save
                respond_with_lesli(:turbo => [
                    stream_notification_success("Discussion updated #{@discussable}"),
                    turbo_stream.replace(helpers.dom_id(@discussion, scope_key)) do 
                        LesliView::Items::Discussion.new(@discussion, scope_key).render_in(view_context)
                    end
                ])
            end

            private

            # return a key to identify the engine where the tasks are running
            def scope_key = ActiveSupport::Inflector.underscore(discussion_class.name).tr("/", "_")

            # return the discussion class including the engine where the tasks are running
            def discussion_class = self.class.module_parent.const_get("Discussion")

            # validate we invoke only models that implements Lesli::Item::Discussions concern
            def validate_discussable discussable

                # 1. Attempt to resolve the class safely
                klass = discussable.safe_constantize

                # 2. VALIDATION: Check if the class is allowed to be discussable
                # We check if the class exists AND if it includes your specific discussable trait
                unless klass && klass.respond_to?(:is_lesli_taskable?) && klass.is_lesli_commentable?
                    render json: { error: "Unauthorized discussable type" }, status: :forbidden and return
                end

                klass
            end

            def set_discussion
                @discussion = discussion_class.where(account: current_user.account).find(params[:id])
            end

            # Permite filtrar/crear para un actionable específico:
            # params: actionable_type=LesliSupport::Ticket&actionable_id=123
            def set_discussable
                type = params[:discussable_type].presence
                id   = params[:discussable_id].presence
                return if type.blank? || id.blank?

                discussable = validate_discussable(type)

                # 3. Execution: Now it is safe to query
                @discussable = discussable.where(account: current_user.account).find_by(id: id)
            end

            def discussion_params
                params.require(scope_key.to_sym).permit(:message)
            end
        end
    end
end
