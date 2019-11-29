module Courier
    module Bell
        class Notifications
            def self.getNotifications(user:, subject:, body:nil, href:nil, format:'info')
                ::Bell::Notification.new({
                    body: body,
                    href: href,
                    format: format,
                    subject: subject,
                    users_id: user.id,
                    bells_id: user.account.id
                }).save!
                LesliChannel.broadcast_to("Lesli", channel: "/cloud/layout/header/notification#getNotificationsCounter")
            end
        end
    end
end
