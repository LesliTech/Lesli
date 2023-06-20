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

class SystemActivitiesController < ApplicationController
  before_action :set_system_activity, only: [:show, :edit, :update, :destroy]

  # GET /system_activities
  def index
    @system_activities = SystemActivity.all
  end

  # GET /system_activities/1
  def show
  end

  # GET /system_activities/new
  def new
    @system_activity = SystemActivity.new
  end

  # GET /system_activities/1/edit
  def edit
  end

  # POST /system_activities
  def create
    @system_activity = SystemActivity.new(system_activity_params)

    if @system_activity.save
      redirect_to @system_activity, notice: 'System activity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /system_activities/1
  def update
    if @system_activity.update(system_activity_params)
      redirect_to @system_activity, notice: 'System activity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /system_activities/1
  def destroy
    @system_activity.destroy
    redirect_to system_activities_url, notice: 'System activity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_activity
      @system_activity = SystemActivity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_activity_params
      params.fetch(:system_activity, {})
    end
end
