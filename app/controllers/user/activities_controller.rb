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

class User::ActivitiesController < ApplicationController
  before_action :set_user_activity, only: [:show, :edit, :update, :destroy]

  # GET /user/activities
  def index
    @user_activities = User::Activity.all
  end

  # GET /user/activities/1
  def show
  end

  # GET /user/activities/new
  def new
    @user_activity = User::Activity.new
  end

  # GET /user/activities/1/edit
  def edit
  end

  # POST /user/activities
  def create
    @user_activity = User::Activity.new(user_activity_params)

    if @user_activity.save
      redirect_to @user_activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/activities/1
  def update
    if @user_activity.update(user_activity_params)
      redirect_to @user_activity, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/activities/1
  def destroy
    @user_activity.destroy
    redirect_to user_activities_url, notice: 'Activity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_activity
      @user_activity = User::Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_activity_params
      params.fetch(:user_activity, {})
    end
end
