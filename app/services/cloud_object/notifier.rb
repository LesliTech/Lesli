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
class CloudObject::Notifier
    def self.notify_status_update(current_user, cloud_object, old_attributes, new_attributes)
        status = cloud_object.status
        return unless status

        foreign_key = status.class.table_name

        if old_attributes["#{foreign_key}_id"] != new_attributes["#{foreign_key}_id"]
            self.create_notification(current_user, cloud_object, "object_status_updated") do |cloud_object, payload|
                yield(cloud_object, payload) if block_given?
            end
        end
    end

    # If there are no attributes, we immediately send the notification, otherwise, we check updated_at values
    def self.notify_update(current_user, cloud_object, old_attributes, new_attributes, updated_table)
        if old_attributes.nil? || (old_attributes["updated_at"] != new_attributes["updated_at"])
            self.create_notification(current_user, cloud_object, "object_updated") do |cloud_object, payload|
                yield(cloud_object, payload) if block_given?
            end
        end
    end

    protected

    def self.create_notification(current_user, cloud_object, action)
        cloud_object.subscribers.where(
            action: action
        ).where.not(
            user_creator: current_user
        ).each do |subscriber|
            payload = {
                subject: "",
                body: "",
                url: "",
                category: "info",
                channel: subscriber.notification_type
            }

            # This yield is in charge of modifying the payload values
            yield(cloud_object, payload) if block_given?

            Courier::Bell::Notification.new(
                subscriber.user_creator,
                payload[:subject],
                body: payload[:body],
                url: payload[:url],
                category: payload[:info],
                channel: payload[:channel]
            )
        end
    end
end
