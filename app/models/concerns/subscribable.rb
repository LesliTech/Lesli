module Subscribable include ActiveSupport::Concern

    # Suscribes the user to a single event, or all events
    def add_subscriber(user, event=nil, notification_type=nil)
        notification_type = :web unless notification_type
        if event
            subscribers.create(user: user, event: event, notification_type: class_subscriber.notification_types[notification_type])
        end
        
        class_subscriber.events.values.each do |event|
            subscribers.create(user: user, event: event, notification_type: class_subscriber.notification_types[notification_type])
        end
    end

    def notify_subscribers(subject, event)
        subscribers.where(event: event).each do |subscriber|
            Courier::Bell::Notifications.send(
                user: subscriber.user,
                subject: subject,
                href: build_reference
            )
        end
    end

    def subscription_events
        data = { }
        events = class_subscriber.events.keys
        events.each do |event|
            data[event] = {
                event: event,
                subscribed: false
            }
        end
        subscribers.each do |subscriber|
            data[subscriber.event][:id] = subscriber.id
            data[subscriber.event][:subscribed] = true
            data[subscriber.event][:notification_type] = subscriber.notification_type
        end
        data.values
    end

    private

    def build_reference
        path = self.class.name.sub("Cloud","").downcase.split("::")
        "/#{path[0]}/#{path[1]}s/#{id}"
    end

    def class_subscriber
        "#{self.class.name}::Subscriber".constantize
    end

end
