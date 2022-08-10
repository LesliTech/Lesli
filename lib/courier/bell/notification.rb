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
                pagination = {
                    "pages" =>0,
                    "page" => 0,
                    "total" => 0,
                    "count" =>0
                }
                return pagination if not defined? CloudBell
                CloudBell::Notification.index(current_user, query, only_own_notifications)
            end

            def self.read(current_user, id)
                return 0 if not defined? CloudBell
                CloudBell::Notification.read(current_user, id)
            end

            def self.new(
                user, 
                subject, 
                url:nil, 
                body:nil,
                media:nil, 
                payload:nil, 
                channel:nil,
                category:nil, 
                notification_type:nil, 
                user_receiver_id:nil, 
                role_receiver_names:nil, 
                user_receiver_emails:nil
            )

                # exit if CloudBell is not installed
                return { :id => 0 } if not defined? CloudBell
                CloudBell::NotificationService.generate(
                    user,
                    subject,
                    url: url,
                    body: body,
                    media: media,
                    payload: payload,
                    channel: channel,
                    category: category,
                    user_receiver_id: user_receiver_id,
                    notification_type: notification_type,
                    role_receiver_names: role_receiver_names,
                    user_receiver_emails: user_receiver_emails,
                )
            end

        end
    end
end
