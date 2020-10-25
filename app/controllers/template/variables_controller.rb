class Template::VariablesController < ApplicationLesliController
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
end
