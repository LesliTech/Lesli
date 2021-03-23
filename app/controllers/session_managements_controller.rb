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

class SessionManagementsController < ApplicationLesliController
    before_action :set_session_management, only: [:update, :destroy]

    # GET /session_managements/
    def index
        respond_to do |format|
            format.html {}
            format.json { respond_with_successful(User::Session.index(current_user, @query)) }
        end
    end

    # GET /session_managements/1
    def show
    end

    # GET /session_managements/1
    def new
    end

    # GET /session_managements/1/edit
    def edit
    end

    # POST /session_managements
    def create
    end

    # PATCH/PUT /session_managements/1
    def update
    end

    # DELETE /session_managements/1
    def destroy
        return respond_with_not_found unless @session_management
        current_user.logs.create({ session_uuid: @session_management.session_uuid, title: "session_closing_successful", description: "closing session from session managements, session_id: #{@session_management.id.to_s} " })
        @session_management.update({ expiration_at: LC::Date.now })

        if @session_management.delete
            respond_with_successful
        else
            respond_with_error(@session_management.errors.full_messages.to_sentence)
        end
    end

    private

    def set_session_management
        @session_management = User::Session.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def session_management_params
        params.require(:session_management).permit(
            :id,
        )
    end

end