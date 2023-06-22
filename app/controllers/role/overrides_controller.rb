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

class Role::OverridesController < ApplicationController
  before_action :set_role_override, only: [:show, :edit, :update, :destroy]

  # GET /role/overrides
  def index
    @role_overrides = Role::Override.all
  end

  # GET /role/overrides/1
  def show
  end

  # GET /role/overrides/new
  def new
    @role_override = Role::Override.new
  end

  # GET /role/overrides/1/edit
  def edit
  end

  # POST /role/overrides
  def create
    @role_override = Role::Override.new(role_override_params)

    if @role_override.save
      redirect_to @role_override, notice: 'Override was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /role/overrides/1
  def update
    if @role_override.update(role_override_params)
      redirect_to @role_override, notice: 'Override was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /role/overrides/1
  def destroy
    @role_override.destroy
    redirect_to role_overrides_url, notice: 'Override was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role_override
      @role_override = Role::Override.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_override_params
      params.fetch(:role_override, {})
    end
end
