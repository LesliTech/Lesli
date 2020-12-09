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

            def self.index(current_user, query, view_type)
                return 0 if not defined? CloudBell
                CloudBell::Notification.index(current_user, query, view_type)
            end

            def self.new(user, subject, url:nil, kind:"info")
                return if not defined? CloudBell
                user.account.bell.notifications.create({
                    subject: subject,
                    kind: kind,
                    user: user,
                    url: url
                })
            end

        end
    end
end
