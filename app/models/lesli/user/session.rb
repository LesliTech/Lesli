=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

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

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class User::Session < ApplicationLesliRecord
        belongs_to :user

        after_create :set_session_token

        enum :session_source, {
            :dispatcher_standard_session => "dispatcher_standard_session",
            :devise_standard_session => "devise_standard_session"
        }

        def set_session_token

            return if self.session_source == "devise_standard_session"

            return unless self.session_token.blank?

            rebuild_token = true

            while rebuild_token do

                session_token = SecureRandom.alphanumeric(20)

                # assign token to user if token is unique
                unless User::Session.find_by(:session_token => session_token)
                    self.session_token = session_token
                    self.save!
                    rebuild_token = false
                end

            end

        end

        def active?
            if self.deleted_at.present?
                return false
            end

            if self.expiration_at != nil and self.expiration_at < Time.now.utc
                return false
            end

            return true
        end
    end
end
