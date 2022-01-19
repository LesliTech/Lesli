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

class InvitesMailer < ApplicationLesliMailer
    include Devise::Controllers::UrlHelpers

    def invitation_card

        build_data_from_params(params)
        #@app[:host]
        mail(to: 'ldonis.emc2@gmail.com', subject: 'Welcome to My Awesome Site')

        #invite = params[:invite]
        #build_data_from_params(params)
        #mail(to: email_address_with_name(invite.email, invite.full_name), subject: "Lesli - Invitation")
    end

end
