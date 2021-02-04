=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Bell
        class Notification

            def self.count(current_user)
                return 0 if not defined? CloudBell
                CloudBell::Notification.count(current_user)
            end

            def self.index(current_user, query, view_type)
                return [] if not defined? CloudBell
                CloudBell::Notification.index(current_user, query, view_type)
            end

            def self.new(user, subject, body:nil, url:nil, category:nil)
                return if not defined? CloudBell
                user.account.bell.notifications.create({
                    subject: subject,
                    body: body,
                    kind: category,
                    user: user,
                    url: url
                })
                #LesliChannel.broadcast_to("Lesli", channel: "/lesli/layout/header/notification#getNotificationsCounter")
            end

        end
    end
end
