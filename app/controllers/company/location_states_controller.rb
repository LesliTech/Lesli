class Company::LocationStatesController < ApplicationController
  before_action :set_company_location_state, only: [:show, :edit, :update, :destroy]

  # GET /company/location_states
  def index
    @company_location_states = Company::LocationState.all
  end

  # GET /company/location_states/1
  def show
  end

  # GET /company/location_states/new
  def new
    @company_location_state = Company::LocationState.new
  end

  # GET /company/location_states/1/edit
  def edit
  end

  # POST /company/location_states
  def create
    @company_location_state = Company::LocationState.new(company_location_state_params)

    if @company_location_state.save
      redirect_to @company_location_state, notice: 'Location state was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/location_states/1
  def update
    if @company_location_state.update(company_location_state_params)
      redirect_to @company_location_state, notice: 'Location state was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/location_states/1
  def destroy
    @company_location_state.destroy
    redirect_to company_location_states_url, notice: 'Location state was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_location_state
      @company_location_state = Company::LocationState.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_location_state_params
      params.fetch(:company_location_state, {})
    end
end
