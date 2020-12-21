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
    module Driver
        class Calendar

            def self.events_register_for(
                current_user, reference_name, reference_id, 
                title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil
            )
                return unless defined? CloudDriver
                current_user.account.driver.calendars.default.events.create({
                    reference_name: reference_name, 
                    reference_id: reference_id,
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

            def self.events_update_for(
                current_user, reference_name, reference_id, 
                title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil
            )
                return unless defined? CloudDriver
                events = current_user.account.driver.calendars.default.events.where(reference_name: reference_name, reference_id: reference_id)

                events.each do |event|
                    event.detail.title = title unless title.blank?
                    event.detail.description = description unless description.blank?
                    event.detail.time_start = time_start unless time_start.blank?
                    event.detail.time_end = time_end unless time_end.blank?
                    event.detail.location = location unless location.blank?
                    event.detail.url = url unless url.blank?
                    event.save!
                end

            end


            
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
                .select(:id, :title, :description, :event_date, :time_start, :time_end, :location, :url, :event_type, :public, :model_type)
            end

            def self.events_from_all_modules(current_user, query)
                return unless defined? CloudDriver
                current_user.account.driver.calendars.events_from_all_modules(current_user, query)
            end

        end
    end
end
