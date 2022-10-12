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

class ProfilesController < ApplicationLesliController

    def privileges
        {
            show: [
                # 'UsersController#update',
                'UsersController#options',
                'User::SessionsController#index',
                # 'User::SessionsController#destroy',
                # 'User::SettingsController#create',
                'Profile::SubscriptionsController#index',
                'Profile::SubscriptionsController#options',
                'Profile::NotificationsController#index',
                'CloudBell::AnnouncementsController#list',
            ]
        }
    end

    # GET /profile
    def show
        respond_to do |format|
            format.html {}
            format.json { respond_with_successful(current_user.show(current_user)) }
        end
    end

end
