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

class User::SessionsController < ApplicationLesliController
    before_action :set_user_session, only: [:show, :edit, :update, :destroy]

    # GET /user/sessions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                if params[:user_id].to_i != current_user.id and not current_user.has_privileges?(["users"], ["index"])
                    return respond_with_unauthorized
                end
                return respond_with_successful(User::Session.index(current_user, @query, params, session[:user_session_id]))
            end
        end
    end

    # GET /user/sessions/1
    def show
    end

    # GET /user/sessions/new
    def new
    end

    # GET /user/sessions/1/edit
    def edit
    end

    # POST /user/sessions
    def create
    end

    # PATCH/PUT /user/sessions/1
    def update
    end

    # DELETE /user/sessions/1
    def destroy
        return respond_with_not_found unless @user_session

        if @user_session.delete
            current_user.logs.create({ 
                user_sessions_id: @user_session.id, 
                title: "session_closed_successful", 
                description: "closing session from session managements" 
            })
            respond_with_successful
          else
            respond_with_error(@user_session.errors.full_messages.to_sentence)
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
    def set_user_session
        if params[:user_id].to_i != current_user.id and not current_user.has_privileges?(["users"], ["index"])
            return
        end
        @user_session = User::Session.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_session_params
        params.require(:user_session).permit(:id,)
    end
end
