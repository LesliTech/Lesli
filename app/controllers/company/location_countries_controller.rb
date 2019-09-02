class Company::LocationCountriesController < ApplicationController
  before_action :set_company_location_country, only: [:show, :edit, :update, :destroy]

  # GET /company/location_countries
  def index
    @company_location_countries = Company::LocationCountry.all
  end

  # GET /company/location_countries/1
  def show
  end

  # GET /company/location_countries/new
  def new
    @company_location_country = Company::LocationCountry.new
  end

  # GET /company/location_countries/1/edit
  def edit
  end

  # POST /company/location_countries
  def create
    @company_location_country = Company::LocationCountry.new(company_location_country_params)

    if @company_location_country.save
      redirect_to @company_location_country, notice: 'Location country was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/location_countries/1
  def update
    if @company_location_country.update(company_location_country_params)
      redirect_to @company_location_country, notice: 'Location country was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/location_countries/1
  def destroy
    @company_location_country.destroy
    redirect_to company_location_countries_url, notice: 'Location country was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_location_country
      @company_location_country = Company::LocationCountry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_location_country_params
      params.fetch(:company_location_country, {})
    end
end
