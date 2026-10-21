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
        class Activity < ApplicationRecord
            self.abstract_class = true

            # Activity ownership contract:
            # - subject is the resource affected by the event.
            # - actor is the Lesli user who performed the event. The existing
            #   user_id column is kept as the foreign key.
            # - account is declared by the concrete engine model.
            # - activity_code is a semantic event name, not a column name.
            belongs_to :actor, class_name: "Lesli::User", foreign_key: :user_id
            belongs_to :subject, polymorphic: true

            validate :metadata_is_an_object
            validates :activity_type, presence: true
            validates :activity_code,
                presence: true,
                format: {
                    with: /\A[a-z][a-z0-9_]*\z/,
                    message: "must be a semantic snake_case event name"
                }

            private

            def metadata_is_an_object
                return if metadata.is_a?(Hash)

                errors.add(:metadata, "must be a JSON object")
            end
        end
    end
end
