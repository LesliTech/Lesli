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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Bell
        class Notification

            def self.count(current_user, only_own_notifications=false)
                return 0 unless defined? CloudBell
                CloudBell::Notification.count(current_user, only_own_notifications)
            end

            def self.index(current_user, query, only_own_notifications=false)
                return [] unless defined? CloudBell
                CloudBell::Notification.index(current_user, query, only_own_notifications)
            end

            def self.read(current_user, id)
                return 0 unless defined? CloudBell
                CloudBell::Notification.read(current_user, id)
            end

            def self.new(
                user,
                subject,
                url:nil,
                body:nil,
                media:nil,
                payload:nil,
                channel:nil,
                category:nil,
                notification_type:nil,
                user_receiver_id:nil,
                role_receiver_names:nil,
                user_receiver_emails:nil
            )

                # exit if CloudBell is not installed
                return { :id => 0 } unless defined? CloudBell
                CloudBell::NotificationService.generate(
                    user,
                    subject,
                    url: url,
                    body: body,
                    media: media,
                    payload: payload,
                    channel: channel,
                    category: category,
                    user_receiver_id: user_receiver_id,
                    notification_type: notification_type,
                    role_receiver_names: role_receiver_names,
                    user_receiver_emails: user_receiver_emails,
                )
            end

        end
    end
end
