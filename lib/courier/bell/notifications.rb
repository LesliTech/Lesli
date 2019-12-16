module Courier
    module Bell
        class Notifications

            def self.send(user:, subject:, body:nil, href:nil, format:'info', type: 'web', cloud_object_type: 'resource')
                return unless defined? CloudBell

                case type
                when 'web'
                    self.send_web(user, subject, body, href, format)
                when 'email'
                    self.send_email(user, subject, body, href, format, cloud_object_type)
                else
                    self.send_web(user, subject, body, href, format)
                    
                end
            end

            private

            def self.send_web(user, subject, body, href, format)
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

            def self.count(user)
                unless defined? CloudBell
                    return 0
                end
                user.notifications.length
            end

            def self.send_email(user, subject, body, href, format, cloud_object_type)
                NotificationMailer.with(
                    user: user,
                    subject: subject,
                    body: body,
                    href: href,
                    format: format,
                    cloud_object_type: cloud_object_type
                ).notify.deliver_later
            end
        end
    end
end
