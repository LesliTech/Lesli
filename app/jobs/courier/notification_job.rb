class Courier::NotificationJob < ApplicationJob
    queue_as :default
    def perform(user:, subject:, body:nil, href:nil, format:'info')
        Bell::Notification.new({
            subject: subject,
            body: body,
            href: href,
            format: format,
            users_id: user.id,
            bells_id: user.account.id
        }).save!
        LesliChannel.broadcast_to("Lesli", channel: "/cloud/layout/header/notification#getNotificationsCounter")
    end
end
