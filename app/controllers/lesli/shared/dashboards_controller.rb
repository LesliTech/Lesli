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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end
module Lesli
    module Shared
        class DashboardsController < ApplicationLesliController
            #before_action :set_dashboard, only: [:show, :update, :destroy, :options]

            def edit 
                # renders the edit view for dashboard
            end

            def show 
                builder = LesliSystem::Klass.new(self)
                @dashboard = builder.model.dashboard.first
            end

            # def index
            #     respond_to do |format|
            #         format.html {}
            #         format.json do
            #             dynamic_info = self.class.dynamic_info
            #             model = dynamic_info[:model]

            #             dashboards = model.list(current_user, @query)
            #             respond_with_successful(dashboards)
            #         end
            #     end
            # end

            # def show
            #     respond_to do |format|
            #         format.html {}
            #         format.json do
            #             return respond_with_not_found unless @dashboard
            #             respond_with_successful(@dashboard.show)
            #         end
            #     end
            # end

            # def new
            # end

            # def edit
            # end

            # # @controller_action_param :name [String] The name of the new dashboard
            # # @controller_action_param :default [Boolean] A flag that marks this dashboard as default or not. The default dashboard is the dashboard all users will have access to on the root page
            # # @controller_action_param :main    [Boolean] A flag that marks this dashboard as main. Since a user can have multiple dashboards, this is the one they will see on the root page when loging in
            # # @controller_action_param :roles_id [Integer] The id of the role that will have access to this dashboard
            # # @controller_action_param :user_main_id [Integer] The id of the user 
            # # @controller_action_param :component_attributes [Array] Array of hashes that represent the attributes of the dashboard components
            # # @controller_action_param :component_attributes.name [String] The name of this component given to the user
            # # @controller_action_param :component_attributes.component_id [String] An enum value, that indicates which component is being loaded
            # # @controller_action_param :component_attributes.layout [Integer] Number from 1 to 12, bigger numbers default to 12, smallest numbers default to 1. The column size that the UI component will use
            # # @controller_action_param :component_attributes.index [Integer] The position of the component in the layout
            # # @controller_action_param :component_attributes.configuration [Hash] Specific filtering and configuration of the components
            # # @return [Json] Json that contains wheter the creation of the dashboard was successful or not. 
            # #     If it is not successful, it returns an error message
            # # @description Creates a new dashboard associated to the *current_user*'s *account*
            # # @example
            # # # Executing this controller's action from javascript's frontend
            # #     let data = {
            # #         dashboard: {
            # #             name: "Sales Dashboard",
            # #             default: false,
            # #             roles_id: 3,
            # #             components_attributes: [
            # #                 {
            # #                     name: 'Projects Count',
            # #                     component_id: projects_component,
            # #                     layout: 4,
            # #                     index: 3,
            # #                     configuration: {}
            # #                 }, {
            # #                     name: 'New Customers Count',
            # #                     component_id: new_customers_component,
            # #                     layout: 4,
            # #                     index: 3,
            # #                     configuration: {}
            # #                 }
            # #             ]
            # #         }
            # #     };
            # #     this.http.post('127.0.0.1/help/dashboards', data);
            # def create
            #     dynamic_info = self.class.dynamic_info
            #     module_name = dynamic_info[:module_name]
            #     model = dynamic_info[:model]
            #     full_module_name = dynamic_info[:full_module_name].underscore

            #     dashboard = model.new(dashboard_params)
            #     dashboard["#{full_module_name}_account_id".to_sym] = current_user.account.id
            #     dashboard.user_creator = current_user

            #     if dashboard.save
            #         respond_with_successful(dashboard)
            #     else
            #         respond_with_error(dashboard.errors.full_messages.to_sentence)
            #     end
            # end

            # # @controller_action_param :name [String] The name of the new dashboard
            # # @controller_action_param :default [Boolean] A flag that marks this dashboard as default or not. The default dashboard is the dashboard all users will have access to on the root page
            # # @controller_action_param :main    [Boolean] A flag that marks this dashboard as main. Since a user can have multiple dashboards, this is the one they will see on the root page when loging in
            # # @controller_action_param :roles_id [Integer] The id of the role that will have access to this dashboard
            # # @controller_action_param :user_main_id [Integer] The id of the user 
            # # @controller_action_param :component_attributes [Array] Array of hashes that represent the attributes of the dashboard components
            # # @controller_action_param :component_attributes.name [String] The name of this component given to the user
            # # @controller_action_param :component_attributes.component_id [String] An enum value, that indicates which component is being loaded
            # # @controller_action_param :component_attributes.layout [Integer] Number from 1 to 12, bigger numbers default to 12, smallest numbers default to 1. The column size that the UI component will use
            # # @controller_action_param :component_attributes.index [Integer] The position of the component in the layout
            # # @controller_action_param :component_attributes.configuration [Hash] Specific filtering and configuration of the components
            # # @return [Json] Json that contains wheter the dashboard was successfully updated or not. 
            # #     If it it not successful, it returns an error message
            # # @description Updates an existing dashboard associated to the *current_user*'s *account*.
            # # @example
            # # # Executing this controller's action from javascript's frontend
            # # let dashboard_id = 4;
            # # let data = {
            # #     dashboard: {
            # #         name: "Sales Dashboard",
            # #         default: false,
            # #         roles_id: 3,
            # #         components_attributes: [
            # #             {
            # #                 name: 'Projects Count',
            # #                 component_id: projects_component,
            # #                 layout: 4,
            # #                 index: 3,
            # #                 configuration: {}
            # #             }, {
            # #                 name: 'New Customers Count',
            # #                 component_id: new_customers_component,
            # #                 layout: 4,
            # #                 index: 3,
            # #                 configuration: {}
            # #             }
            # #         ]
            # #     }
            # # };
            # # this.http.put(`127.0.0.1/help/dashboards/${dashboard_id}`, data);
            # def update
            #     return respond_with_not_found unless @dashboard

            #     if @dashboard.update(dashboard_params)
            #         respond_with_successful(@dashboard.show)
            #     else
            #         respond_with_error(@dashboard.errors.full_messages.to_sentence)
            #     end
            # end

            # # @return [Json] Json that contains wheter the dashboard was successfully deleted or not. 
            # #     If it it not successful, it returns an error message
            # # @description Deletes an existing *dashboard* associated to the *current_user*'s *account*.
            # #     Since the dashboard has details, these are also deleted. However, if there
            # #     is an existing *cloud_object* associated to the *dashboard*, it cannot be deleted
            # # @example
            # #     # Executing this controller's action from javascript's frontend
            # #     let dashboard_id = 4;
            # #     this.http.delete(`127.0.0.1/help/dashboards/${dashboard_id}`);
            # def destroy
            #     return respond_with_not_found unless @dashboard

            #     if @dashboard.destroy
            #         respond_with_successful
            #     else
            #         respond_with_error(@dashboard.errors.full_messages.to_sentence)
            #     end
            # end

            # def options
            #     dynamic_info = self.class.dynamic_info
            #     model = dynamic_info[:module_model]

            #     respond_with_successful(model.options(current_user, @query))
            # end

            # def resource_component
            #     dynamic_info = self.class.dynamic_info
            #     component_model = dynamic_info[:component_model]

            #     component_id = sanitize(params[:component_id].to_sym)

            #     # We verify if the method exists, and if it is in the available component list
            #     if component_model.respond_to?(component_id) && component_model.component_ids[component_id]
            #         respond_with_successful(component_model.public_send(component_id, current_user, @query))
            #     else
            #         respond_with_not_found()
            #     end
            # end

            # private

            # # @return [void]
            # # @description Sets the variable @dashboard. The variable contains the *cloud_object* *dashboard* 
            # #     to be handled by the controller action that called this method
            # # @example
            # #     #suppose params[:id] = 1
            # #     puts @dashboard # will display nil
            # #     set_dashboard
            # #     puts @dashboard # will display an instance of CloudHelp:TicketDashboard
            # def set_dashboard
            #     dynamic_info = self.class.dynamic_info

            #     model = dynamic_info[:module_model]
            #     module_name = dynamic_info[:module_name]
            #     module_name_full = dynamic_info[:module_name_full].underscore

            #     # When params[:id] is 'default' order of priority is:
            #     # Main dashboard for user goes first
            #     # Main dashboard for role goes second
            #     # Default dashboard goes third
            #     if params[:id] == "default"
            #         # Main dashboard for user
            #         @dashboard = model.find_by(
            #             #"#{full_module_name}_account_id".to_sym => current_user.account.id,
            #             account_id: current_user.account.id,
            #             main: true,
            #             #user_main_id: current_user.id
            #         )

            #         return if @dashboard
                    
            #         # Main dashboard for role
            #         # @dashboard = model.find_by(
            #         #     :account_id => current_user.account.id,
            #         #     role_id: current_user.roles.first.id
            #         # )
            #         # return if @dashboard

            #         # Default dashboard
            #         @dashboard = model.find_by(
            #             account_id: current_user.account.id,
            #             default: true
            #         )
            #     else
            #         @dashboard = model.find_by(
            #             id: params[:id],
            #             :account_id => current_user.account.id,
            #         )
            #     end
            # end

            # def dashboard_params
            #     params.require(:dashboard).permit(
            #         :name,
            #         :default,
            #         :roles_id,
            #         components_attributes: [
            #             :id,
            #             :name,
            #             :component_id,
            #             :layout,
            #             :index,
            #             {query_configuration: {}},
            #             {custom_configuration: {}},
            #             :_destroy
            #         ]
            #     )
            # end

            # private

            # # Build the Rails models and engine information for 
            # # the current engine implementing the shared dashboards
            # # Example: For the LesliAudit engine
            # # {
            # #     :module_name => "audit", 
            # #     :module_name_full => "LesliAudit", 
            # #     :module_model => "LesliAudit::Dashboard", 
            # #     :module_model_component => "LesliAudit::Dashboard::Component"
            # # }
            # def self.dynamic_info

            #     module_info = self.name.split("::")

            #     module_name = module_info[0].sub("Lesli", "").downcase
                
            #     {
            #         module_name: module_name,
            #         module_name_full: module_info[0],
            #         module_model: "#{ module_info[0] }::Dashboard".constantize,
            #         module_model_component: "#{ module_info[0] }::Dashboard::Component".constantize
            #     }
            # end
        end
    end
end
