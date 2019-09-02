class Company::LocationContinentsController < ApplicationController
  before_action :set_company_location_continent, only: [:show, :edit, :update, :destroy]

  # GET /company/location_continents
  def index
    @company_location_continents = Company::LocationContinent.all
  end

  # GET /company/location_continents/1
  def show
  end

  # GET /company/location_continents/new
  def new
    @company_location_continent = Company::LocationContinent.new
  end

  # GET /company/location_continents/1/edit
  def edit
  end

  # POST /company/location_continents
  def create
    @company_location_continent = Company::LocationContinent.new(company_location_continent_params)

    if @company_location_continent.save
      redirect_to @company_location_continent, notice: 'Location continent was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/location_continents/1
  def update
    if @company_location_continent.update(company_location_continent_params)
      redirect_to @company_location_continent, notice: 'Location continent was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/location_continents/1
  def destroy
    @company_location_continent.destroy
    redirect_to company_location_continents_url, notice: 'Location continent was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_location_continent
      @company_location_continent = Company::LocationContinent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_location_continent_params
      params.fetch(:company_location_continent, {})
    end
end
