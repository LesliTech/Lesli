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
    before_action :set_user_session, only: [:destroy]

    # GET /user/sessions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_pagination(User::Session.index(current_user, @query, params, session[:user_session_id]))
            end
        end
    end

    # DELETE /user/sessions/1
    def destroy
        return respond_with_not_found unless @user_session

        if @user_session.delete
            current_user.logs.create({title: "close_session",description: "by_user: " + current_user.email})
            respond_with_successful
          else
            respond_with_error(@user_session.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_session
        @user_session = User::Session.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_session_params
        params.require(:user_session).permit(:id,)
    end
end
