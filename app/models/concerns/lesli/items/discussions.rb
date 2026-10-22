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
        module Discussions
            extend ActiveSupport::Concern
            include Lesli::Items::Ownership

            included do
                class_attribute :lesli_discussions_class, instance_accessor: false
                class_attribute :lesli_discussions_association_name,
                    instance_accessor: false,
                    default: :discussions
                lesli_discussions_setup
            end

            class_methods do

                # This acts as our allowlist flag
                def is_lesli_commentable?
                    true
                end

                # Resolve the concrete discussion model for the engine.
                def lesli_discussions_setup(use: nil, as: :discussable, association_name: :discussions)
                    klass = if use
                        use.to_s.constantize
                    else
                        "#{name.deconstantize}::Items::Discussion".constantize
                    end

                    self.lesli_discussions_class = klass
                    self.lesli_discussions_association_name = association_name.to_sym

                    # ✅ Auto-fix table name (works even when engine defines table_name_prefix)
                    expected_table = lesli_expected_discussions_table_name_for(klass)

                    if klass.table_name != expected_table
                        klass.table_name = expected_table
                    end

                    has_many(association_name,
                        -> { order(created_at: :desc, id: :desc) },
                        as: as,
                        class_name: klass.name,
                        dependent: :destroy)
                end

                private

                # Build: "lesli_support_items_discussions" from
                # "LesliSupport::Items::Discussion"
                #
                # We DO NOT rely on ActiveRecord's table_name_prefix, because that’s what breaks your case.
                def lesli_expected_discussions_table_name_for(klass)
                    parts = klass.name.split("::").map(&:underscore)
                    "#{parts.join('_').pluralize}"
                end
            end

            def add_comment!(author:, message:)
                discussion_association.create!(
                    author: author,
                    account: lesli_item_account,
                    message: message
                )
            end

            private

            def discussion_association
                public_send(self.class.lesli_discussions_association_name)
            end
        end
    end
end
