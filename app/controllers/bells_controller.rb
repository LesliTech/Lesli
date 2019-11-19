class BellsController < ApplicationController
  before_action :set_bell, only: [:show, :edit, :update, :destroy]

  # GET /bells
  def index
    @bells = Bell.all
  end

  # GET /bells/1
  def show
  end

  # GET /bells/new
  def new
    @bell = Bell.new
  end

  # GET /bells/1/edit
  def edit
  end

  # POST /bells
  def create
    @bell = Bell.new(bell_params)

    if @bell.save
      redirect_to @bell, notice: 'Bell was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bells/1
  def update
    if @bell.update(bell_params)
      redirect_to @bell, notice: 'Bell was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bells/1
  def destroy
    @bell.destroy
    redirect_to bells_url, notice: 'Bell was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bell
      @bell = Bell.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bell_params
      params.fetch(:bell, {})
    end
end
