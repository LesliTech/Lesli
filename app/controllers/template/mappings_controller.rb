class Template::MappingsController < ApplicationController
  before_action :set_template_mapping, only: [:show, :edit, :update, :destroy]

  # GET /template/mappings
  def index
    @template_mappings = Template::Mapping.all
  end

  # GET /template/mappings/1
  def show
  end

  # GET /template/mappings/new
  def new
    @template_mapping = Template::Mapping.new
  end

  # GET /template/mappings/1/edit
  def edit
  end

  # POST /template/mappings
  def create
    @template_mapping = Template::Mapping.new(template_mapping_params)

    if @template_mapping.save
      redirect_to @template_mapping, notice: 'Mapping was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /template/mappings/1
  def update
    if @template_mapping.update(template_mapping_params)
      redirect_to @template_mapping, notice: 'Mapping was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /template/mappings/1
  def destroy
    @template_mapping.destroy
    redirect_to template_mappings_url, notice: 'Mapping was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_mapping
      @template_mapping = Template::Mapping.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def template_mapping_params
      params.fetch(:template_mapping, {})
    end
end
