class Account::LocationsController < ApplicationLesliController
    before_action :set_account_location, only: [:update, :destroy]
 
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
 