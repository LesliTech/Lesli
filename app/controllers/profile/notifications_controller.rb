=begin

Copyright (c) 2021, all rights reserved.

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

class Profile::NotificationsController < ApplicationLesliController

    # GET /profile/notifications
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Profile::Notification.index(current_user, @query))
            end
        end
    end

    def update
        respond_with_successful(Profile::Notification.read(current_user, params[:id]))
    end

    private

    # Only allow a list of trusted parameters through.
    def profile_notification_params
        params.require(:profile_notification).permit(:id, :name)
    end
end
