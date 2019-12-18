module Subscribable include ActiveSupport::Concern

    # Suscribes the user to a single event, or all events
    def add_subscriber(user, event=nil, notification_type=nil)
        notification_type = :web unless notification_type
        if event
            subscribers.create(user: user, event: event, notification_type: dynamic_class.notification_types[notification_type])
        end
        
        dynamic_class.events.values.each do |event|
            subscribers.create(user: user, event: event, notification_type: dynamic_class.notification_types[notification_type])
        end
    end

    def notify_subscribers(subject, event)
        subscribers.where(event: event).each do |subscriber|
            Courier::Bell::Notifications.send(
                user: subscriber.user,
                subject: subject,
                href: build_reference,
                type: subscriber.notification_type,
                cloud_object_type: module_name
            )
        end
    end

    def subscription_events(user)
        data = { }
        events = dynamic_class.events.keys
        events.each do |event|
            data[event] = {
                event: event,
                subscribed: false
            }
        end
        subscribers.where(users_id: user.id).each do |subscriber|
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

    def dynamic_class
        "#{self.class.name}::Subscriber".constantize
    end

    def module_name
        path = self.class.name.sub("Cloud","").sub("::","/")
    end

end
