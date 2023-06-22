=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class InvitesController < ApplicationController
    include Interfaces::Application::Responder
    protect_from_forgery with: :null_session
    
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
