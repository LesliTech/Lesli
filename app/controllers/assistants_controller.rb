class AssistantsController < ApplicationLesliController

    def lesli_dashboard
        Courier::Bell::NotificationJob.perform_now(
            user: current_user,
            subject: 'New notification',
            href: '/test'
        )
    end

end
