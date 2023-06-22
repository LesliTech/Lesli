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

class Account::LocationsController < ApplicationLesliController
    before_action :set_account_location, only: [:show, :update, :destroy]

    # GET /locations
    def index
        respond_with_successful(Account::Location.list(current_user, @query))
    end

    # POST /locations
    def create
        location = Account::Location.new(location_params)
        location.account = current_user.account

        if location.save
            respond_with_successful(location)
        else
            respond_with_error(location.errors.full_messages.to_sentence)
        end
    end

    # GET /locations
    def show
        respond_to do |format|
            format.html {}
            format.json {
                return respond_with_not_found unless @location

                respond_with_successful(@location.show)
            }
        end
    end

    private

    # @return [void]
    # @description Sets the location based on the current_users's account
    # @example
    #     # Executing this method from a controller action:
    #     set_account_location
    #     puts @location
    #     # This will either display nil or an instance of Account::Location
    def set_account_location
        @location = current_user.account.locations.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
        params.fetch(:location, {}).permit(
            :name,
            :short_name,
            :postal_code,
            :latitude,
            :longitude,
            :code,
            :level,
            :native_level,
            :parent_id
        )
    end
 end
