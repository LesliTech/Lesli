class Account::LocationsController < ApplicationController
  before_action :set_account_location, only: [:show, :edit, :update, :destroy]

  # GET /account/locations
  def index
    @account_locations = Account::Location.all
  end

  # GET /account/locations/1
  def show
  end

  # GET /account/locations/new
  def new
    @account_location = Account::Location.new
  end

  # GET /account/locations/1/edit
  def edit
  end

  # POST /account/locations
  def create
    @account_location = Account::Location.new(account_location_params)

    if @account_location.save
      redirect_to @account_location, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /account/locations/1
  def update
    if @account_location.update(account_location_params)
      redirect_to @account_location, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /account/locations/1
  def destroy
    @account_location.destroy
    redirect_to account_locations_url, notice: 'Location was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_location
      @account_location = Account::Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_location_params
      params.fetch(:account_location, {})
    end
end
