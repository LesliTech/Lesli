class SystemActivitiesController < ApplicationController
  before_action :set_system_activity, only: [:show, :edit, :update, :destroy]

  # GET /system_activities
  def index
    @system_activities = SystemActivity.all
  end

  # GET /system_activities/1
  def show
  end

  # GET /system_activities/new
  def new
    @system_activity = SystemActivity.new
  end

  # GET /system_activities/1/edit
  def edit
  end

  # POST /system_activities
  def create
    @system_activity = SystemActivity.new(system_activity_params)

    if @system_activity.save
      redirect_to @system_activity, notice: 'System activity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /system_activities/1
  def update
    if @system_activity.update(system_activity_params)
      redirect_to @system_activity, notice: 'System activity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /system_activities/1
  def destroy
    @system_activity.destroy
    redirect_to system_activities_url, notice: 'System activity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_activity
      @system_activity = SystemActivity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_activity_params
      params.fetch(:system_activity, {})
    end
end
