class Lesli::DashboardsController < ApplicationController
  before_action :set_lesli_dashboard, only: [:show, :edit, :update, :destroy]

  # GET /lesli/dashboards
  def index
    @lesli_dashboards = Lesli::Dashboard.all
  end

  # GET /lesli/dashboards/1
  def show
  end

  # GET /lesli/dashboards/new
  def new
    @lesli_dashboard = Lesli::Dashboard.new
  end

  # GET /lesli/dashboards/1/edit
  def edit
  end

  # POST /lesli/dashboards
  def create
    @lesli_dashboard = Lesli::Dashboard.new(lesli_dashboard_params)

    if @lesli_dashboard.save
      redirect_to @lesli_dashboard, notice: 'Dashboard was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lesli/dashboards/1
  def update
    if @lesli_dashboard.update(lesli_dashboard_params)
      redirect_to @lesli_dashboard, notice: 'Dashboard was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lesli/dashboards/1
  def destroy
    @lesli_dashboard.destroy
    redirect_to lesli_dashboards_url, notice: 'Dashboard was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesli_dashboard
      @lesli_dashboard = Lesli::Dashboard.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lesli_dashboard_params
      params.fetch(:lesli_dashboard, {})
    end
end
