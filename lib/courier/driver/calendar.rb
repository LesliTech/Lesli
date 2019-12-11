module Courier
    module Driver
        class Calendar
            def initialize(calendar="default")
                @calendar="default"
            end
            def self.registerEvent(user, title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil)
                unless defined? CloudDriver
                    return
                end

                calendar = CloudDriver::Calendar.default
                event = CloudDriver::Event.create({
                    calendar: calendar,
                    detail_attributes: {
                        title: title,
                        description: description,
                        time_start: time_start,
                        time_end: time_end,
                        location: location,
                        url: url
                    }
                })
            end
        end
    end
end
