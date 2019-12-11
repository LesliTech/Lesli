class DashboardsController < ApplicationLesliController

    def empty
        Courier::Driver::Calendar.registerEvent(current_user, 
            title: 'my event', 
            time_start: DateTime.now,
            time_end: 2.days.from_now
        )
    end

end
