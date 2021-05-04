=begin
Copyright (c) 2021, all rights reserved.
All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.
Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end
module CloudObject
    class Notifier
        def self.notify_status_update(current_user, cloud_object, old_attributes, new_attributes)
            status = cloud_object.status
            return unless status

            foreign_key = status.class.table_name

            if old_attributes["#{foreign_key}_id"] != new_attributes["#{foreign_key}_id"]
                self.create_notification(current_user, cloud_object) do |cloud_object, payload|
                    yield(cloud_object, payload) if block_given?
                end
            end
        end

        def self.notify_update(current_user, cloud_object, old_attributes, new_attributes)
            if old_attributes.updated_at != new_attributes.updated_at
                self.create_notification(current_user, cloud_object) do |cloud_object, payload|
                    yield(cloud_object, payload) if block_given?
                end
            end
        end

        protected

        def self.create_notification(current_user, cloud_object)
            cloud_object.subscribers.where(
                action: "object_status_updated"
            ).where.not(
                user_creator: current_user
            ).each do |subscriber|
                payload = {
                    subject: "",
                    body: "",
                    url: "",
                    kind: "info",
                    sender: subscriber.notification_type
                }

                # This yield is in charge of modifying the payload values
                yield(cloud_object, payload) if block_given?
            
                Courier::Bell::Notification.new(
                    subscriber.user_creator,
                    payload[:subject],
                    body: payload[:body],
                    url: payload[:url],
                    kind: payload[:info],
                    sender: payload[:sender]
                )
            end
        end
    end
end
