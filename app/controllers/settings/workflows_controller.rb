class Settings::WorkflowsController < ApplicationLesliController
  before_action :set_settings_workflow, only: [:show, :edit, :update, :destroy]

  # GET /settings/workflows
  def index
    @settings_workflows = Settings::Workflow.all
  end

  # GET /settings/workflows/1
  def show
  end

  # GET /settings/workflows/new
  def new
    @settings_workflow = Settings::Workflow.new
  end

  # GET /settings/workflows/1/edit
  def edit
  end

  # POST /settings/workflows
  def create
    @settings_workflow = Settings::Workflow.new(settings_workflow_params)

    if @settings_workflow.save
      redirect_to @settings_workflow, notice: 'Workflow was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /settings/workflows/1
  def update
    if @settings_workflow.update(settings_workflow_params)
      redirect_to @settings_workflow, notice: 'Workflow was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /settings/workflows/1
  def destroy
    @settings_workflow.destroy
    redirect_to settings_workflows_url, notice: 'Workflow was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_settings_workflow
      @settings_workflow = Settings::Workflow.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def settings_workflow_params
      params.fetch(:settings_workflow, {})
    end
end
