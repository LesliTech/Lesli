module Courier
    module Driver
        class Calendar
            def self.registerEvent(user, title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil)
                return unless defined? CloudDriver
                user.account.driver.calendars.default.events.create({
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
        end
    end
end
