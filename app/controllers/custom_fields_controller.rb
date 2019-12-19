class CustomFieldsController < ApplicationController
  before_action :set_custom_field, only: [:show, :edit, :update, :destroy]

  # GET /custom_fields
  def index
    @custom_fields = CustomField.all
  end

  # GET /custom_fields/1
  def show
  end

  # GET /custom_fields/new
  def new
    @custom_field = CustomField.new
  end

  # GET /custom_fields/1/edit
  def edit
  end

  # POST /custom_fields
  def create
    @custom_field = CustomField.new(custom_field_params)

    if @custom_field.save
      redirect_to @custom_field, notice: 'Custom field was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /custom_fields/1
  def update
    if @custom_field.update(custom_field_params)
      redirect_to @custom_field, notice: 'Custom field was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /custom_fields/1
  def destroy
    @custom_field.destroy
    redirect_to custom_fields_url, notice: 'Custom field was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_field
      @custom_field = CustomField.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def custom_field_params
      params.fetch(:custom_field, {})
    end
end
