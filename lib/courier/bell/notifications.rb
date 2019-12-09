module Courier
    module Bell
        class Notifications
            def self.send(user:, subject:, body:nil, href:nil, format:'info')
                unless defined? CloudBell
                    return
                end
                return if user.account.bell.blank?
                CloudBell::Notification.new({
                    body: body,
                    href: href,
                    format: format,
                    subject: subject,
                    users_id: user.id,
                    cloud_bell_accounts_id: user.account.id
                }).save!
                LesliChannel.broadcast_to("Lesli", channel: "/cloud/layout/header/notification#getNotificationsCounter")
            end
        end
    end
end
