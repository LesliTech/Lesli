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

class User::TokensController < ApplicationController
    before_action :set_user_token, only: [:show, :update, :destroy]

    # GET /user/tokens/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::TokenServices.new(current_user, query).list)
            end
        end
    end

    # GET /user/tokens
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(User::TokenServices.new(current_user, query).index)
            end
        end
    end

    # GET /user/tokens/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@user_token.show)
            end
        end
    end

    # GET /user/tokens/new
    def new
    end

    # GET /user/tokens/:id/edit
    def edit
    end

    # POST /user/tokens
    def create
        user_token = User::TokenServices.new(current_user, query).create(user_token_params)
        if user_token.successful?
            respond_with_successful(user_token.result)
        else
            respond_with_error(user_token.errors)
        end
    end

    # PATCH/PUT /user/tokens/:id
    def update
        @user_token.update(user_token_params)

        if @user_token.successful?
            respond_with_successful(@user_token.result)
        else
            respond_with_error(@user_token.errors)
        end
    end

    # DELETE /user/tokens/1
    def destroy
        return respond_with_not_found unless @user_token

        if @user_token.destroy
            respond_with_successful
        else
            respond_with_error(@user_token.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_token
        @user_token = User::TokenServices.new(current_user, query).find(params[:id])
        return respond_with_not_found unless @user_token.found?
    end

    # Only allow a list of trusted parameters through.
    def user_token_params
        params.require(:user_token).permit(:id, :name)
    end
end
