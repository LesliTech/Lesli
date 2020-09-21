class Account::ActivitiesController < ApplicationController
  before_action :set_account_activity, only: [:show, :edit, :update, :destroy]

  # GET /account/activities
  def index
    @account_activities = Account::Activity.all
  end

  # GET /account/activities/1
  def show
  end

  # GET /account/activities/new
  def new
    @account_activity = Account::Activity.new
  end

  # GET /account/activities/1/edit
  def edit
  end

  # POST /account/activities
  def create
    @account_activity = Account::Activity.new(account_activity_params)

    if @account_activity.save
      redirect_to @account_activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /account/activities/1
  def update
    if @account_activity.update(account_activity_params)
      redirect_to @account_activity, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /account/activities/1
  def destroy
    @account_activity.destroy
    redirect_to account_activities_url, notice: 'Activity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_activity
      @account_activity = Account::Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_activity_params
      params.fetch(:account_activity, {})
    end
end
