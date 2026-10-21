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
        class AttachmentsController < ApplicationLesliController
            include ActiveStorage::SetCurrent

            before_action :set_attachable, only: %i[index create]
            before_action :set_attachment, only: %i[show destroy]

            def index
                attachments = @attachable.attachments.with_attached_file
                respond_with_lesli(json: attachments.map { |attachment| attachment_payload(attachment) })
            end

            def show
                return respond_with_not_found unless @attachment.file.attached?

                redirect_to(
                    @attachment.file.url(
                        expires_in: 5.minutes,
                        disposition: :attachment,
                        filename: @attachment.file.filename
                    ),
                    allow_other_host: true
                )
            end

            def create
                attachment = @attachable.attachments.build(attachment_params)
                attachment.user = current_user
                attachment.account = current_user.account

                if attachment.save
                    refresh_attachments
                    respond_with_lesli(
                        turbo: [
                            stream_notification_success(
                                I18n.t("lesli.items.attachments.created")
                            ),
                            attachments_stream
                        ],
                        json: attachment_payload(attachment),
                        redirect: return_path
                    )
                else
                    respond_with_lesli(
                        turbo: [
                            stream_notification_danger(
                                attachment.errors.full_messages.to_sentence
                            ),
                            attachments_stream(attachment: attachment)
                        ],
                        json: { errors: attachment.errors },
                        redirect: return_path,
                        status: :unprocessable_content
                    )
                end
            end

            def destroy
                attachable = @attachment.attachable

                if @attachment.destroy
                    @attachable = attachable
                    refresh_attachments
                    respond_with_lesli(
                        turbo: [
                            stream_notification_success(
                                I18n.t("lesli.items.attachments.deleted")
                            ),
                            attachments_stream
                        ],
                        json: { message: I18n.t("lesli.items.attachments.deleted") },
                        redirect: return_path
                    )
                else
                    respond_with_lesli(
                        turbo: stream_notification_danger(
                            @attachment.errors.full_messages.to_sentence
                        ),
                        json: { errors: @attachment.errors },
                        redirect: return_path,
                        status: :unprocessable_content
                    )
                end
            end

            private

            def attachment_class
                self.class.module_parent.const_get("Attachment")
            end

            def attachable_class
                klass = params[:attachable_type].to_s.safe_constantize

                unless klass&.respond_to?(:is_lesli_attachable?) &&
                    klass.is_lesli_attachable?
                    raise ActiveRecord::RecordNotFound,
                        "Unauthorized attachable type"
                end

                klass
            end

            def set_attachable
                @attachable = attachable_class.find(params.require(:attachable_id))
                ensure_attachable_access!(@attachable)
            end

            def set_attachment
                @attachment = attachment_class
                    .with_attached_file
                    .where(account: current_user.account)
                    .find(params[:id])
                ensure_attachable_access!(@attachment.attachable)
            end

            def ensure_attachable_access!(attachable)
                allowed = attachable.respond_to?(:lesli_item_accessible_by?) &&
                    attachable.lesli_item_accessible_by?(current_user)

                raise ActiveRecord::RecordNotFound unless allowed
            end

            def attachment_params
                params.require(scope_key).permit(:file, :label, :category)
            end

            def scope_key
                ActiveSupport::Inflector.underscore(attachment_class.name).tr("/", "_")
            end

            def attachment_payload(attachment)
                {
                    id: attachment.id,
                    label: attachment.label,
                    category: attachment.category,
                    filename: attachment.file.filename.to_s,
                    content_type: attachment.file.blob.content_type,
                    byte_size: attachment.file.blob.byte_size,
                    created_at: attachment.created_at,
                    user: {
                        id: attachment.user_id,
                        name: attachment.user.name
                    }
                }
            end

            def attachments_stream(attachment: nil)
                turbo_stream.replace(
                    helpers.dom_id(@attachable, :attachments)
                ) do
                    LesliView::Items::Attachments
                        .new(@attachable, attachment: attachment)
                        .render_in(view_context)
                end
            end

            def refresh_attachments
                @attachable.attachments.reset
            end

            def return_path
                request.referer.presence || root_path
            end
        end
    end
end
