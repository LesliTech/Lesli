class Template::VariablesController < ApplicationLesliController
    before_action :set_template_variable, only: [:show, :edit, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                template_variables = current_user.account.template.variables.order(:variable_type)

                respond_with_successful(template_variables)
            end
        end 
    end

    def options
        respond_with_successful(Template::Variable.options(current_user, @query))
    end

end
