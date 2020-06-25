class Account::LocationsController < ApplicationLesliController
    before_action :set_location, only: [:show, :edit, :update, :destroy]
 
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
            respond_with_error(locations.errors.full_messages.to_sentence)
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
 