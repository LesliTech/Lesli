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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

module Lesli
    class UsersController < ApplicationController
        before_action :set_user, only: %i[show edit update destroy]

        # GET /users
        def index
            @users = User.all
        end

        # GET /users/1
        def show; end

        # GET /users/new
        def new
            @user = User.new
        end

        # GET /users/1/edit
        def edit; end

        # POST /users
        def create
            @user = User.new(user_params)

            if @user.save
                redirect_to @user, notice: "User was successfully created."
            else
                render :new, status: :unprocessable_entity
            end
        end

        # PATCH/PUT /users/1
        def update
            if @user.update(user_params)
                redirect_to @user, notice: "User was successfully updated."
            else
                render :edit, status: :unprocessable_entity
            end
        end

        # DELETE /users/1
        def destroy
            @user.destroy
            redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_user
            @user = User.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def user_params
            params.fetch(:user, {})
        end
    end
end
