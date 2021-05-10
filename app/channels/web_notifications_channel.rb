class WebNotificationsChannel < ApplicationCable::Channel
    def subscribed
        # stream_from "some_channel"
        stream_from "web_notifications_channel_#{ current_user.id }"
    end

    def receive(data)
        #ActionCable.server.broadcast('web_notifications_channel', message: LC::Date2.new.date_time.to_s)
        #ActionCable.server.broadcast('web_notifications_channel', message: Courier::Bell::Notification.count(current_user))
    end


    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end
