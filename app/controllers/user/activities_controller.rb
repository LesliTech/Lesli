class User::ActivitiesController < ApplicationController
  before_action :set_user_activity, only: [:show, :edit, :update, :destroy]

  # GET /user/activities
  def index
    @user_activities = User::Activity.all
  end

  # GET /user/activities/1
  def show
  end

  # GET /user/activities/new
  def new
    @user_activity = User::Activity.new
  end

  # GET /user/activities/1/edit
  def edit
  end

  # POST /user/activities
  def create
    @user_activity = User::Activity.new(user_activity_params)

    if @user_activity.save
      redirect_to @user_activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/activities/1
  def update
    if @user_activity.update(user_activity_params)
      redirect_to @user_activity, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/activities/1
  def destroy
    @user_activity.destroy
    redirect_to user_activities_url, notice: 'Activity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_activity
      @user_activity = User::Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_activity_params
      params.fetch(:user_activity, {})
    end
end
