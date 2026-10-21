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
        module Attachments
            extend ActiveSupport::Concern

            included do
                class_attribute :lesli_attachments_class, instance_accessor: false
                lesli_attachments_setup
            end

            class_methods do
                def is_lesli_attachable?
                    true
                end

                def lesli_attachments_setup(
                    use: nil,
                    as: :attachable,
                    association_name: :attachments
                )
                    klass = if use
                        use.to_s.constantize
                    else
                        "#{name.deconstantize}::Items::Attachment".constantize
                    end

                    self.lesli_attachments_class = klass

                    expected_table = lesli_expected_attachments_table_name_for(klass)
                    klass.table_name = expected_table if klass.table_name != expected_table

                    has_many(
                        association_name,
                        -> { order(created_at: :desc) },
                        as: as,
                        class_name: klass.name,
                        dependent: :destroy
                    )
                rescue NameError
                    raise NameError,
                        "Attachment class not found for #{name}. " \
                        "Expected #{name.deconstantize}::Items::Attachment or pass `use:`"
                end

                private

                def lesli_expected_attachments_table_name_for(klass)
                    parts = klass.name.split("::").map(&:underscore)
                    parts.join("_").pluralize
                end
            end

            # Resources that belong directly to Lesli::Account can use this
            # implementation. Engine resources whose account is an engine account
            # must override it and return the owning Lesli::Account.
            def lesli_item_account
                account
            end

            def lesli_item_accessible_by?(user)
                user.present? && lesli_item_account == user.account
            end
        end
    end
end
