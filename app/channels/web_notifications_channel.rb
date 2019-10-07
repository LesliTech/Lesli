class WebNotificationsChannel < ApplicationCable::Channel

    def subscribed
        #stream_from "web_notifications_channel"
        #stream_for current_user
        stream_for 'current_user'
    end

    def unsubscribed
    end

end
