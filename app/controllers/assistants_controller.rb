class AssistantsController < ApplicationLesliController

    #load_and_authorize_resource

    def lesli_dashboard
        Courier::Bell::Notifications.getNotifications(
            user: current_user,
            subject: 'New notification',
            href: '/test'
        )
    end

end
