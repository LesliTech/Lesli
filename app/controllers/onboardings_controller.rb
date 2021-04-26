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
    include Application::Responder

    layout "application-public"

    #before_action :configure_sign_up_params, only: [:create]

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
    def create

        token = onboarding_params[:t]

        # validate that token were sent
        if token.blank?
            return respond_with_error(I18n.t("core.users/confirmations.messages_warning_invalid_token"))
        end

        # check if token belongs to a uncofirmed user
        user = User.find_by(:confirmation_token => token)

        # validate that user were found
        if user.blank?
            return respond_with_error(I18n.t("core.users/confirmations.messages_warning_invalid_token"))
        end

        registration = UserRegistrationService.new(user).create_account

        if registration.successful?
            #user.update(registration_token: nil )
            respond_with_successful()
        end
        respond_with_error("Error creating account") if !registration.successful?

    end

    def onboarding_params
        params.require(:onboarding).permit(:t)
    end

end
