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
            before_action :set_discussable, only: :create

            def create
                comment = @discussable.add_comment!(
                    author: current_user,
                    message: discussion_params[:message]
                )
                refresh_discussions

                message = I18n.t("lesli.items.discussions.created")
                respond_with_lesli(
                    turbo: [
                        stream_notification_success(message),
                        discussions_stream
                    ],
                    json: {
                        message: message,
                        comment: comment_payload(comment)
                    },
                    status: :created
                )
            rescue ActiveRecord::RecordInvalid => error
                respond_with_comment_errors(error.record)
            end

            private

            def discussable_class
                klass = params.require(:discussable_type).safe_constantize

                return klass if klass&.respond_to?(:is_lesli_commentable?) &&
                    klass.is_lesli_commentable?

                raise ActiveRecord::RecordNotFound
            end

            def set_discussable
                @discussable = discussable_class.find(
                    params.require(:discussable_id)
                )
                ensure_discussable_access!(@discussable)
            end

            def ensure_discussable_access!(discussable)
                allowed = discussable.respond_to?(:lesli_item_accessible_by?) &&
                    discussable.lesli_item_accessible_by?(current_user)

                raise ActiveRecord::RecordNotFound unless allowed
            end

            def discussion_class
                @discussable.class.lesli_discussions_class
            end

            def scope_key
                ActiveSupport::Inflector
                    .underscore(discussion_class.name)
                    .tr("/", "_")
            end

            def discussion_params
                params.require(scope_key.to_sym).permit(:message)
            end

            def refresh_discussions
                association_name =
                    @discussable.class.lesli_discussions_association_name

                @discussable.public_send(association_name).reset
            end

            def discussions_stream(comment: nil)
                turbo_stream.replace(
                    helpers.dom_id(@discussable, :discussions)
                ) do
                    LesliView::Items::Discussions
                        .new(@discussable, comment: comment)
                        .render_in(view_context)
                end
            end

            def comment_payload(comment)
                {
                    id: comment.id,
                    message: comment.message,
                    discussable_type: comment.discussable_type,
                    discussable_id: comment.discussable_id,
                    author: {
                        id: comment.user_id,
                        name: comment.author.name
                    },
                    created_at: comment.created_at,
                    updated_at: comment.updated_at
                }
            end

            def respond_with_comment_errors(comment)
                refresh_discussions
                message = I18n.t("lesli.items.discussions.invalid")
                respond_with_lesli(
                    turbo: [
                        stream_notification_danger(message),
                        discussions_stream(comment: comment)
                    ],
                    json: {
                        message: message,
                        errors: comment.errors
                    },
                    status: :unprocessable_content
                )
            end
        end
    end
end
