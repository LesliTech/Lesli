module CloudObject
    class Subscriber < ApplicationRecord
        self.abstract_class = true

        belongs_to :user, class_name: "User", foreign_key: "users_id"

        enum event: [
            :comment_created,
            :action_created,
            :file_created,
            :activity_created,
            :workflow_updated,
            :priority_updated,
            :http_get,
            :http_post,
            :http_put,
            :http_patch,
            :http_update
        ]
        validates :event, presence: true, inclusion: { in: :event }

        enum notification_type: [
            :web,
            :email
        ]
        validates :notification_type, presence: true, inclusion: { in: :notification_type }

        def self.add_subscriber(cloud_object, user, event=nil, notification_type=nil)
            model = dynamic_info[:model]

            notification_type = :web unless notification_type
            if event
                return cloud_object.subscribers.create(
                    user: user,
                    event: event,
                    notification_type: model.notification_types[notification_type]
                )
            end
            
            model.events.values.each do |event|
                cloud_object.subscribers.create(
                    user: user,
                    event: event,
                    notification_type: model.notification_types[notification_type]
                )
            end
        end
    
        def self.notify_subscribers(cloud_object, subject, event)
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            cloud_object.subscribers.where(event: event).each do |subscriber|
                Courier::Bell::Notifications.send(
                    user: subscriber.user,
                    subject: subject,
                    href: "#{module_name}/#{object_name}/#{cloud_object.id}",
                    type: subscriber.notification_type,
                    cloud_object_type: "#{module_name}/#{object_name}"
                )
            end
        end
    
        def self.subscription_events(cloud_object, user)
            model = dynamic_info[:model]

            data = { }
            events = model.events.keys
            events.each do |event|
                data[event] = {
                    event: event,
                    subscribed: false,
                    notification_type: :web
                }
            end
            cloud_object.subscribers.where(users_id: user.id).each do |subscriber|
                data[subscriber.event][:id] = subscriber.id
                data[subscriber.event][:subscribed] = true
                data[subscriber.event][:notification_type] = subscriber.notification_type
            end
            data.values
        end
    
        private

        # Obtains model, module and object name.
        # For example, model would be CloudHelp::Ticket::Subscriber, module_name would be 'help' and object_name would be 'ticket'
        def self.dynamic_info
            module_info = self.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end

    end
end
