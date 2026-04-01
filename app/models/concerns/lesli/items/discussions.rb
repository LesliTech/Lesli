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

            included do
                class_attribute :lesli_discussions_class, instance_accessor: false
                lesli_discussions_setup
            end

            class_methods do

                # This acts as our allowlist flag
                def is_lesli_commentable?
                    true
                end

                # Automatically sets the associations to the
                # engine model that is implementing the task items
                def lesli_discussions_setup(use: nil, as: :discussable, association_name: :discussions)
                    klass = if use
                        use.to_s.constantize
                    else
                        "#{name.deconstantize}::Items::Discussion".constantize
                    end

                    self.lesli_discussions_class = klass

                    # ✅ Auto-fix table name (works even when engine defines table_name_prefix)
                    expected_table = lesli_expected_discussions_table_name_for(klass)

                    if klass.table_name != expected_table
                        klass.table_name = expected_table
                    end

                    # Set associations
                    # Example:
                    # class LesliSupport::Ticket 
                    #     has_many :lesli_support_tasks
                    # end
                    has_many(association_name,
                        -> { where(deleted_at: nil).order(created_at: :desc) },
                        as: as,
                        class_name: klass.name,
                        dependent: :destroy)
                end

                private

                # Build: "lesli_support_item_activities" from "LesliSupport::Item::Activity"
                #
                # We DO NOT rely on ActiveRecord's table_name_prefix, because that’s what breaks your case.
                def lesli_expected_discussions_table_name_for(klass)
                    parts = klass.name.split("::").map(&:underscore) # ["lesli_support", "item", "discussion"]
                    "#{parts.join('_').pluralize}"                   # "lesli_support_item_discussions"
                end
            end
        end
    end
end
