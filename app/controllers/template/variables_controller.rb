class Template::VariablesController < ApplicationController
    before_action :set_template_variable, only: [:show, :edit, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                template_variables = current_user.account.template.variables

                respond_with_successful(template_variables)
            end
        end 
    end

  # GET /template/variables/1
  def show
  end

  # GET /template/variables/new
  def new
    @template_variable = Template::Variable.new
  end

  # GET /template/variables/1/edit
  def edit
  end

  # POST /template/variables
  def create
    @template_variable = Template::Variable.new(template_variable_params)

    if @template_variable.save
      redirect_to @template_variable, notice: 'Variable was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /template/variables/1
  def update
    if @template_variable.update(template_variable_params)
      redirect_to @template_variable, notice: 'Variable was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /template/variables/1
  def destroy
    @template_variable.destroy
    redirect_to template_variables_url, notice: 'Variable was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_variable
      @template_variable = Template::Variable.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def template_variable_params
      params.require(:template_variable).permit(:field_name, :table_name, :alias)
    end
end
