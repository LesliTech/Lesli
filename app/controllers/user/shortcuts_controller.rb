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
class User::ShortcutsController < ApplicationLesliController
    before_action :set_user_shortcut, only: [:show, :update, :destroy]

    # GET /user/shortcuts
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::Shortcut.index(current_user, @query, params))
            end
        end
    end

    # POST /user/shortcuts
    def create
        return respond_with_error unless @current_user.shortcuts.new(user_shortcut_params).valid?

        # get the website title prefix from the lesli.yml file
        title_prefix = Rails.application.config.lesli.dig(:account, :website, :title_prefix)

        # remove the default prefix from the final shortcutname
        shortcut_name = (user_shortcut_params[:name]).gsub("#{ title_prefix } · ", "")

        # save shortcut if url does not exists
        user_shortcut = current_user.shortcuts
        .create_with(name: shortcut_name)
        .find_or_create_by(url: user_shortcut_params[:url])

        if user_shortcut.save
            respond_with_successful(user_shortcut)
        else
            respond_with_error(user_shortcut.errors.full_messages.to_sentence)
        end
        
    end

    # PATCH/PUT /user/shortcuts/1
    def update
        return respond_with_not_found unless @user_shortcut
        if @user_shortcut.update(user_shortcut_params)
            respond_with_successful(@user_shortcut.show(current_user, @query))
        else
            respond_with_error(@user_shortcut.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/shortcuts/1
    def destroy
        return respond_with_not_found unless @user_shortcut
        if @user_shortcut.destroy
            respond_with_successful
        else
            respond_with_error(@user_shortcut.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_shortcut
        @user_shortcut = User.find_by(id: params[:user_id]).shortcuts.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_shortcut_params
        params.require(:user_shortcut).permit(:id, :name, :icon, :url, :engine_code)
    end

end
