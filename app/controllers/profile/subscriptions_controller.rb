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
class Profile::SubscriptionsController < ApplicationLesliController

    def index
        respond_to do |format|
            format.html {}
            format.json do
                subscriptions = Profile::Subscription.index(current_user, @query)
                respond_with_successful(subscriptions)
            end
        end
    end

    def options
        respond_with_successful(Profile::Subscription.options(current_user, @query))
    end

    def update
    end

    def destroy
    end
end
