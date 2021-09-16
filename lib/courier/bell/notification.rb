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

            def self.count(current_user, only_own_notifications=false)
                return 0 if not defined? CloudBell
                CloudBell::Notification.count(current_user, only_own_notifications)
            end

            def self.index(current_user, query, only_own_notifications=false)
                return [] if not defined? CloudBell
                CloudBell::Notification.index(current_user, query, only_own_notifications)
            end

            def self.read(current_user, id)
                return 0 if not defined? CloudBell
                CloudBell::Notification.read(current_user, id)
            end

            def self.new(user, subject, role_names:nil, body:nil, url:nil, kind:nil, category:nil)
                return if not defined? CloudBell

                if not user or role_names
                    notifications = []
                    User.joins(:roles).where("roles.name in (?)", role_names).each do |user|
                        notification = user.account.bell.notifications.create({
                            category: category,
                            subject: subject,
                            status: 'created',
                            body: body,
                            user: user,
                            url: url
                        })

                        notifications.append({ id: notification.id })
                    end

                    return notifications
                else
                    notification = user.account.bell.notifications.create({
                        category: category,
                        subject: subject,
                        status: 'created',
                        body: body,
                        user: user,
                        url: url
                    })

                    return { id: notification.id }
                end

            end

        end
    end
end
