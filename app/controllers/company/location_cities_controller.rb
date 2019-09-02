class Company::LocationCitiesController < ApplicationController
  before_action :set_company_location_city, only: [:show, :edit, :update, :destroy]

  # GET /company/location_cities
  def index
    @company_location_cities = Company::LocationCity.all
  end

  # GET /company/location_cities/1
  def show
  end

  # GET /company/location_cities/new
  def new
    @company_location_city = Company::LocationCity.new
  end

  # GET /company/location_cities/1/edit
  def edit
  end

  # POST /company/location_cities
  def create
    @company_location_city = Company::LocationCity.new(company_location_city_params)

    if @company_location_city.save
      redirect_to @company_location_city, notice: 'Location city was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/location_cities/1
  def update
    if @company_location_city.update(company_location_city_params)
      redirect_to @company_location_city, notice: 'Location city was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/location_cities/1
  def destroy
    @company_location_city.destroy
    redirect_to company_location_cities_url, notice: 'Location city was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_location_city
      @company_location_city = Company::LocationCity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_location_city_params
      params.fetch(:company_location_city, {})
    end
end
