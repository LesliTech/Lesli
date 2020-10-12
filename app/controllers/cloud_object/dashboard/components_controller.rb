module CloudObject
    class Dashboard::ComponentsController < ApplicationLesliController
        before_action :set_dashboard, only: [:index, :create]
        before_action :set_dashboard_component, only: [:destroy]


        def show
            respond_to do |format|
                format.html {}
                format.json do
                    set_dashboard_component
                    return respond_with_not_found unless @dashboard_component

                    if params[:view_type] == "render"
                        component_data = @dashboard_component.render_data(current_user, @query)

                        return respond_with_successful(component_data) if component_data
                        return respond_with_unauthorized
                    end

                    respond_with_successful(@dashboard_component) 
                end
            end
        end

private

        def set_dashboard

            dynamic_info = self.class.dynamic_info
            dashboard_model = dynamic_info[:dashboard_model]
            module_name = dynamic_info[:module_name]

            @dashboard = dashboard_model.find_by(
                id: params[:dashboard_id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

        def set_dashboard_component
            set_dashboard
            return unless @dashboard

            @dashboard_component = @dashboard.components.find_by(id: params[:id])
        end

=begin
@return [Parameters] Allowed parameters for the dashboard
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    If there are extra allowed params, they must be implemented on the subclass
@example
    # supose params contains {
    #    dashboard_component: {
    #       dashboard_for: 'projects'
    #       id: 10
    #    }
    #}
    filtered_params = component_params
    puts filtered_params
    # will remove the unpermitted params and only print {
    #       dashboard_for: 'projects'
    #    }
=end
        def component_params
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            params.require(:dashboard_component).permit(
                :next_components,
                :component_type,
                :name,
                :number
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Dashboard::ComponentsController < CloudObject::Dashboard::ComponentsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:model].new # will return an instance of CloudHelp::Dashboard::Component
    puts info[:dashboard_model] # will return an instance of CloudHelp::Dashboard
=end
        def self.dynamic_info
            core_module_info = lesli_classname().split("::")    # This information displays the real core engine
            builder_module_info = self.name.split("::")         # This information displays the builder engine name (if this is an instance of a builder engine)
            lesli_module_name = core_module_info[0].sub("Cloud", "").downcase

            {
                module_name: lesli_module_name,
                model: "#{builder_module_info[0]}::Dashboard::Component".constantize,
                dashboard_model: "#{builder_module_info[0]}::Dashboard".constantize
            }
        end
    end
end
    