class LesliChannel < ApplicationCable::Channel
    def subscribed
        stream_for "Lesli"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end
