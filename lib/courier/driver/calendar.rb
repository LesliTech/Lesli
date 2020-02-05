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
    module Driver
        class Calendar

            def self.events_new(current_user, title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil)
                return unless defined? CloudDriver
                current_user.account.driver.calendars.default.events.create({
                    detail_attributes: {
                        title: title,
                        description: description,
                        time_start: time_start || Time.now,
                        time_end: time_end || Time.now,
                        location: location,
                        url: url
                    }
                })
            end

            def self.events(current_user)
                return unless defined? CloudDriver
                current_user.account.driver.calendars.default.events
                .joins(:detail)
                .select(:id, :title, :description, :time_start, :time_end, :location, :url)
            end

        end
    end
end
