class AssistantsController < ApplicationController

    def lesli_dashboard
        Courier::NotificationJob.perform_now(
            user: current_user,
            subject: 'New notification',
            href: '/test'
        )
    end

end
