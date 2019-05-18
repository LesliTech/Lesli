class Website::LandingsController < ApplicationController
  before_action :set_website_landing, only: [:show, :edit, :update, :destroy]

  # GET /website/landings
  def index
    @website_landings = Website::Landing.all
  end

  # GET /website/landings/1
  def show
  end

  # GET /website/landings/new
  def new
    @website_landing = Website::Landing.new
  end

  # GET /website/landings/1/edit
  def edit
  end

  # POST /website/landings
  def create
    @website_landing = Website::Landing.new(website_landing_params)

    if @website_landing.save
      redirect_to @website_landing, notice: 'Landing was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /website/landings/1
  def update
    if @website_landing.update(website_landing_params)
      redirect_to @website_landing, notice: 'Landing was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /website/landings/1
  def destroy
    @website_landing.destroy
    redirect_to website_landings_url, notice: 'Landing was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_website_landing
      @website_landing = Website::Landing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def website_landing_params
      params.fetch(:website_landing, {})
    end
end
