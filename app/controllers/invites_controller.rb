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
    end

    # POST /invites
    def create
        invite = Invite.new(invite_params)
        success = invite.save

        #InvitesMailer.with(invite).invitation_card.deliver_later if success

        respond_to do |format|
            format.html do 
                if success
                    flash[:success] = "record was successfully saved"
                else
                    flash[:error] = "error"
                end 
                redirect_to root_unauthenticated_path and return 
            end 
            format.json do 
                if success
                    respond_with_successful(invite) if success
                else
                    respond_with_error(invite.errors.full_messages.to_sentence)
                end
            end 
        end 

    end

    private

    # Only allow a list of trusted parameters through.
    def invite_params
        params.require(:invite).permit(:email, :full_name, :telephone, :note)
    end

end
