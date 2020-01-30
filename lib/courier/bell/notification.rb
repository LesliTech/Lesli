=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Bell
        class Notification

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

            def self.register(user, subject, body, href, format)
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

            private

            def self.count(user)
                unless defined? CloudBell
                    return 0
                end
                CloudBell::Notification.where(users_id: user.id, read: false).count
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