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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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
