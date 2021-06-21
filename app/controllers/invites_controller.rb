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

class InvitesController < ApplicationController
    include Application::Responder
    include Application::Logger
    
    # GET /invites/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @invite
                return respond_with_successful(@invite.show(current_user, @query))
            end
        end
    end

    # POST /invites
    def create
        invite = Invite.new(invite_params)
        if invite.save
            respond_with_successful(invite)
        else
            respond_with_error(invite.errors.full_messages.to_sentence)
        end
    end

    private

    # Only allow a list of trusted parameters through.
    def invite_params
        params.require(:invite).permit(:email, :full_name, :telephone, :note)
    end

end
