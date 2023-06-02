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

class User::CodesController < ApplicationController
    before_action :set_user_code, only: [:show, :update, :destroy]

    # GET /user/codes/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::CodeServices.new(current_user, query).list)
            end
        end
    end

    # GET /user/codes
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(User::CodeServices.new(current_user, query).index)
            end
        end
    end

    # GET /user/codes/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@user_code.show)
            end
        end
    end

    # GET /user/codes/new
    def new
    end

    # GET /user/codes/:id/edit
    def edit
    end

    # POST /user/codes
    def create
        user_code = User::CodeServices.new(current_user, query).create(user_code_params)
        if user_code.successful?
            respond_with_successful(user_code.result)
        else
            respond_with_error(user_code.errors)
        end
    end

    # PATCH/PUT /user/codes/:id
    def update
        @user_code.update(user_code_params)

        if @user_code.successful?
            respond_with_successful(@user_code.result)
        else
            respond_with_error(@user_code.errors)
        end
    end

    # DELETE /user/codes/1
    def destroy
        return respond_with_not_found unless @user_code

        if @user_code.destroy
            respond_with_successful
        else
            respond_with_error(@user_code.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_code
        @user_code = User::CodeServices.new(current_user, query).find(params[:id])
        return respond_with_not_found unless @user_code.found?
    end

    # Only allow a list of trusted parameters through.
    def user_code_params
        params.require(:user_code).permit(:id, :name)
    end
end
