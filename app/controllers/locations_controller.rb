class LocationsController < ApplicationLesliController
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    # GET /locations
    def index
        responseWithSuccessful(Location.list(current_user, @query))
    end

    # POST /locations
    def create
        location = Location.new(location_params)

        if location.save
            responseWithSuccessful(location)
        else
            responseWithError("Location not created", locations.errors.full_messages)
        end
    end

    private

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
