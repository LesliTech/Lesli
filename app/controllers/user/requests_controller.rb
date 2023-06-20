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

class User::RequestsController < ApplicationController
  before_action :set_user_request, only: [:show, :edit, :update, :destroy]

  # GET /user/requests
  def index
    @user_requests = User::Request.all
  end

  # GET /user/requests/1
  def show
  end

  # GET /user/requests/new
  def new
    @user_request = User::Request.new
  end

  # GET /user/requests/1/edit
  def edit
  end

  # POST /user/requests
  def create
    @user_request = User::Request.new(user_request_params)

    if @user_request.save
      redirect_to @user_request, notice: 'Request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/requests/1
  def update
    if @user_request.update(user_request_params)
      redirect_to @user_request, notice: 'Request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/requests/1
  def destroy
    @user_request.destroy
    redirect_to user_requests_url, notice: 'Request was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_request
      @user_request = User::Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_request_params
      params.fetch(:user_request, {})
    end
end
