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
    #before_action :set_invite, only: [:show, :update, :destroy]

    include Application::Responder
    include Application::Logger
    

    # GET /invites
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Invite.index(current_user, @query))
            end
        end
    end

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

    # GET /invites/new
    def new
    end

    # GET /invites/1/edit
    def edit
    end

    # POST /invites
    def create
        LC::Debug.msg invite_params
        invite = Invite.new(invite_params)
        if invite.save
            respond_with_successful(invite)
        else
            respond_with_error(invite.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /invites/1
    def update
        return respond_with_not_found unless @invite

        if @invite.update(invite_params)
            respond_with_successful(@invite.show(current_user, @query))
        else
            respond_with_error(@invite.errors.full_messages.to_sentence)
        end
    end

    # DELETE /invites/1
    def destroy
        return respond_with_not_found unless @invite

        if @invite.destroy
            respond_with_successful
        else
            respond_with_error(@invite.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_invite
        @invite = current_user.account.invites.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invite_params
        params.require(:invite).permit(:email, :full_name, :telephone, :note)
    end

end
