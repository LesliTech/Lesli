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

class OnboardingsController < ApplicationController

    layout "application-public"

    # GET /onboardings/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @onboarding
                return respond_with_successful(@onboarding.show(current_user, @query))
            end
        end
    end

    # PATCH/PUT /onboardings/1
    def update
        return respond_with_not_found unless @onboarding

        if @onboarding.update(onboarding_params)
            respond_with_successful(@onboarding.show(current_user, @query))
        else
            respond_with_error(@onboarding.errors.full_messages.to_sentence)
        end
    end

end
