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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Bell
        module Notification
            class Web

                # register a new web notification
                # DEPRECATED: use url instead of href
                def self.new(current_user, subject, href:nil, url:nil, category:"info")

                    return if not defined? CloudBell

                    d = current_user.account.bell.notifications.create({
                        subject: subject,
                        category: category,
                        user: current_user,
                        url: url
                    })

                    LesliChannel.broadcast_to("Lesli", channel: "/core/layout/header/notification#getNotificationsCounter")

                end

                # returns number of not read notifications
                def self.count(current_user)
                    return 0 if not defined? CloudBell

                    #CloudBell::Notification.where(users_id: user.id, read: false).count
                    current_user.account.bell.notifications.where(read: false).count
                end

            end
        end
    end
end
