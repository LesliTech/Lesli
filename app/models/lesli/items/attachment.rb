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
        class Attachment < ApplicationLesliRecord
            DEFAULT_MAX_FILE_SIZE = 25.megabytes
            DEFAULT_CONTENT_TYPES = %w[
                application/pdf
                application/msword
                application/vnd.ms-excel
                application/vnd.ms-powerpoint
                application/vnd.openxmlformats-officedocument.presentationml.presentation
                application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                application/vnd.openxmlformats-officedocument.wordprocessingml.document
                application/zip
                image/gif
                image/jpeg
                image/png
                image/webp
                text/csv
                text/plain
            ].freeze

            self.abstract_class = true

            class_attribute :lesli_attachment_max_file_size,
                instance_accessor: false,
                default: DEFAULT_MAX_FILE_SIZE
            class_attribute :lesli_attachment_content_types,
                instance_accessor: false,
                default: DEFAULT_CONTENT_TYPES

            belongs_to :user, class_name: "Lesli::User"
            belongs_to :account, class_name: "Lesli::Account"
            belongs_to :attachable, polymorphic: true

            has_one_attached :file

            validates :label, length: { maximum: 255 }, allow_blank: true
            validates :category, length: { maximum: 100 }, allow_blank: true
            validate :file_is_attached
            validate :file_size_is_allowed
            validate :file_type_is_allowed

            def display_name
                label.presence || file.filename.to_s
            end

            private

            def file_is_attached
                return if file.attached?

                errors.add(
                    :file,
                    I18n.t("lesli.items.attachments.errors.required")
                )
            end

            def file_size_is_allowed
                return unless file.attached?
                return if file.blob.byte_size <= self.class.lesli_attachment_max_file_size

                errors.add(
                    :file,
                    I18n.t(
                        "lesli.items.attachments.errors.too_large",
                        size: ActiveSupport::NumberHelper.number_to_human_size(
                            self.class.lesli_attachment_max_file_size
                        )
                    )
                )
            end

            def file_type_is_allowed
                return unless file.attached?
                return if self.class.lesli_attachment_content_types.include?(
                    file.blob.content_type
                )

                errors.add(
                    :file,
                    I18n.t("lesli.items.attachments.errors.unsupported_type")
                )
            end
        end
    end
end
