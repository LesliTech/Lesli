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

class Profile::WebpushesController < ApplicationLesliController
    before_action :set_profile_webpush, only: [:show, :update, :destroy]

    # POST /profile/webpushes
    def create
        user_webpush = User::Webpush.new(profile_webpush_params)
        user_webpush.user_agent = get_user_agent
        if user_webpush.save
            respond_with_successful(user_webpush)
        else
            respond_with_error(user_webpush.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_profile_webpush
        @profile_webpush = current_user.account.profile_webpushes.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_webpush_params
        params.require(:profile_webpush).permit(:endpoint, :auth_key, :p256dh_key)
    end
end
