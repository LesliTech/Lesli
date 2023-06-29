=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
module Shared
    class Dashboard::ComponentsController < ApplicationLesliController
        before_action :set_dashboard, only: [:show, :index, :create]
        before_action :set_dashboard_component, only: [:show, :destroy]
        before_action :set_query_for_dashboard

        def set_query_for_dashboard
            @query[:pagination][:perPage] = 5
        end

        def show
            respond_to do |format|
                format.html {}
                format.json do

                    return respond_with_not_found unless @dashboard_component

                    if params[:view] == "data"
                        component_data = @dashboard_component.render_data(current_user, @query)
                        return respond_with_successful(component_data)
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
            full_module_name = dynamic_info[:full_module_name].underscore

            @dashboard = dashboard_model.find_by(
                id: params[:dashboard_id],
                account_id: current_user.account.id
            )
        end

        def set_dashboard_component
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
            full_module_name = dynamic_info[:full_module_name]

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
    # Imagine the current class is an instance of CloudHelp::Dashboard::ComponentsController < Shared::Dashboard::ComponentsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:model].new # will return an instance of CloudHelp::Dashboard::Component
    puts info[:dashboard_model] # will return an instance of CloudHelp::Dashboard
=end
        def self.dynamic_info
            module_info = lesli_classname().split("::")    # This information displays the real core engine
            builder_module_info = self.name.split("::")         # This information displays the builder engine name (if this is an instance of a builder engine)
            lesli_module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: lesli_module_name,
                full_module_name: module_info[0],
                model: "#{builder_module_info[0]}::Dashboard::Component".constantize,
                dashboard_model: "#{builder_module_info[0]}::Dashboard".constantize
            }
        end
    end
end
    