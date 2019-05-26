class Core::AccountPlansController < ApplicationController
  before_action :set_core_account_plan, only: [:show, :edit, :update, :destroy]

  # GET /core/account_plans
  def index
    @core_account_plans = Core::AccountPlan.all
  end

  # GET /core/account_plans/1
  def show
  end

  # GET /core/account_plans/new
  def new
    @core_account_plan = Core::AccountPlan.new
  end

  # GET /core/account_plans/1/edit
  def edit
  end

  # POST /core/account_plans
  def create
    @core_account_plan = Core::AccountPlan.new(core_account_plan_params)

    if @core_account_plan.save
      redirect_to @core_account_plan, notice: 'Account plan was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /core/account_plans/1
  def update
    if @core_account_plan.update(core_account_plan_params)
      redirect_to @core_account_plan, notice: 'Account plan was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /core/account_plans/1
  def destroy
    @core_account_plan.destroy
    redirect_to core_account_plans_url, notice: 'Account plan was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_account_plan
      @core_account_plan = Core::AccountPlan.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_account_plan_params
      params.fetch(:core_account_plan, {})
    end
end
