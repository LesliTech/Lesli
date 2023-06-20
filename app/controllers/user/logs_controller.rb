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

class User::LogsController < ApplicationController
  before_action :set_user_log, only: [:show, :edit, :update, :destroy]

  # GET /user/logs
  def index
    @user_logs = User::Log.all
  end

  # GET /user/logs/1
  def show
  end

  # GET /user/logs/new
  def new
    @user_log = User::Log.new
  end

  # GET /user/logs/1/edit
  def edit
  end

  # POST /user/logs
  def create
    @user_log = User::Log.new(user_log_params)

    if @user_log.save
      redirect_to @user_log, notice: 'Log was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/logs/1
  def update
    if @user_log.update(user_log_params)
      redirect_to @user_log, notice: 'Log was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/logs/1
  def destroy
    @user_log.destroy
    redirect_to user_logs_url, notice: 'Log was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_log
      @user_log = User::Log.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_log_params
      params.fetch(:user_log, {})
    end
end
