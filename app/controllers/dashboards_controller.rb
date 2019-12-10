class DashboardsController < ApplicationLesliController

    def empty
        Courier::Driver::Calendar.registerEvent(current_user, title: 'my event', time_start: DateTime.now)
    end

end
