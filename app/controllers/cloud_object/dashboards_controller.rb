=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module CloudObject
    class DashboardsController < ApplicationLesliController
        before_action :set_dashboard, only: [:update, :destroy]

        # @return [HTML|JSON] HTML view for listing all dashboards or a Json that contains a list 
        #     of all dashboards associated to this *account*
        # @description Retrieves and returns all dashboards associated to a *CloudHelp::Account*. 
        #     The account is obtained directly from *current_user*. The HTTP request has to specify
        #     wheter the HTML or the JSON text should be rendered
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     this.http.get(`127.0.0.1/help/dashboards`);
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    dynamic_info = self.class.dynamic_info
                    model = dynamic_info[:model]

                    dashboards = model.list(current_user, @query)
                    respond_with_successful(dashboards)
                end
            end
        end

        # @return [HTML|Json] HTML view showing the requested dashboard or a Json that contains the
        #     information of the dashboard. If there is an error, an explanation message is sent
        # @description Retrieves and returns the requested dashboard. The id of the 
        #     dashboard is within the *params* attribute of the controller. The HTTP request has to specify
        #     wheter the HTML or the JSON text should be rendered
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let dashboard_id = 1;
        #     this.http.get(`127.0.0.1/help/dashboards/${dashboard_id}`);
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    dynamic_info = self.class.dynamic_info
                    module_name = dynamic_info[:module_name]

                    set_dashboard

                    return respond_with_not_found unless @dashboard
                    
                    respond_with_successful(@dashboard.show)
                end
            end
        end

        # @return [HTML] HTML view for creating a new dashboard
        # @description returns an HTML view with a form so users can create a new dashboard
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     this.url.go('/help/dashboards/new')
        def new
        end

        # @return [HTML] HTML view for editing the dashboard
        # @description returns an HTML view with a form so users edit an existing dashboard
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let dashboard_id = 3;
        #     this.url.go(`/help/dashboards/${dashboard_id}/edit`)
        def edit
        end

        # @controller_action_param :name [String] The name of the new dashboard
        # @controller_action_param :default [Boolean] A flag that marks this dashboard as default or not. The default dashboard is the dashboard all users will have access to on the root page
        # @controller_action_param :main    [Boolean] A flag that marks this dashboard as main. Since a user can have multiple dashboards, this is the one they will see on the root page when loging in
        # @controller_action_param :roles_id [Integer] The id of the role that will have access to this dashboard
        # @controller_action_param :user_main_id [Integer] The id of the user 
        # @controller_action_param :component_attributes [Array] Array of hashes that represent the attributes of the dashboard components
        # @controller_action_param :component_attributes.name [String] The name of this component given to the user
        # @controller_action_param :component_attributes.component_id [String] An enum value, that indicates which component is being loaded
        # @controller_action_param :component_attributes.layout [Integer] Number from 1 to 12, bigger numbers default to 12, smallest numbers default to 1. The column size that the UI component will use
        # @controller_action_param :component_attributes.index [Integer] The position of the component in the layout
        # @controller_action_param :component_attributes.configuration [Hash] Specific filtering and configuration of the components
        # @return [Json] Json that contains wheter the creation of the dashboard was successful or not. 
        #     If it is not successful, it returns an error message
        # @description Creates a new dashboard associated to the *current_user*'s *account*
        # @example
        # # Executing this controller's action from javascript's frontend
        #     let data = {
        #         dashboard: {
        #             name: "Sales Dashboard",
        #             default: false,
        #             roles_id: 3,
        #             components_attributes: [
        #                 {
        #                     name: 'Projects Count',
        #                     component_id: projects_component,
        #                     layout: 4,
        #                     index: 3,
        #                     configuration: {}
        #                 }, {
        #                     name: 'New Customers Count',
        #                     component_id: new_customers_component,
        #                     layout: 4,
        #                     index: 3,
        #                     configuration: {}
        #                 }
        #             ]
        #         }
        #     };
        #     this.http.post('127.0.0.1/help/dashboards', data);
        def create
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]

            dashboard = model.new(dashboard_params)
            dashboard["cloud_#{module_name}_accounts_id".to_sym] = current_user.account.id
            dashboard.user_creator = current_user

            if dashboard.save
                respond_with_successful(dashboard)
            else
                respond_with_error(dashboard.errors.full_messages.to_sentence)
            end
        end

        # @controller_action_param :name [String] The name of the new dashboard
        # @controller_action_param :default [Boolean] A flag that marks this dashboard as default or not. The default dashboard is the dashboard all users will have access to on the root page
        # @controller_action_param :main    [Boolean] A flag that marks this dashboard as main. Since a user can have multiple dashboards, this is the one they will see on the root page when loging in
        # @controller_action_param :roles_id [Integer] The id of the role that will have access to this dashboard
        # @controller_action_param :user_main_id [Integer] The id of the user 
        # @controller_action_param :component_attributes [Array] Array of hashes that represent the attributes of the dashboard components
        # @controller_action_param :component_attributes.name [String] The name of this component given to the user
        # @controller_action_param :component_attributes.component_id [String] An enum value, that indicates which component is being loaded
        # @controller_action_param :component_attributes.layout [Integer] Number from 1 to 12, bigger numbers default to 12, smallest numbers default to 1. The column size that the UI component will use
        # @controller_action_param :component_attributes.index [Integer] The position of the component in the layout
        # @controller_action_param :component_attributes.configuration [Hash] Specific filtering and configuration of the components
        # @return [Json] Json that contains wheter the dashboard was successfully updated or not. 
        #     If it it not successful, it returns an error message
        # @description Updates an existing dashboard associated to the *current_user*'s *account*.
        # @example
        # # Executing this controller's action from javascript's frontend
        # let dashboard_id = 4;
        # let data = {
        #     dashboard: {
        #         name: "Sales Dashboard",
        #         default: false,
        #         roles_id: 3,
        #         components_attributes: [
        #             {
        #                 name: 'Projects Count',
        #                 component_id: projects_component,
        #                 layout: 4,
        #                 index: 3,
        #                 configuration: {}
        #             }, {
        #                 name: 'New Customers Count',
        #                 component_id: new_customers_component,
        #                 layout: 4,
        #                 index: 3,
        #                 configuration: {}
        #             }
        #         ]
        #     }
        # };
        # this.http.put(`127.0.0.1/help/dashboards/${dashboard_id}`, data);
        def update
            return respond_with_not_found unless @dashboard

            if @dashboard.update(dashboard_params)
                respond_with_successful(@dashboard.show)
            else
                respond_with_error(@dashboard.errors.full_messages.to_sentence)
            end
        end

        # @return [Json] Json that contains wheter the dashboard was successfully deleted or not. 
        #     If it it not successful, it returns an error message
        # @description Deletes an existing *dashboard* associated to the *current_user*'s *account*.
        #     Since the dashboard has details, these are also deleted. However, if there
        #     is an existing *cloud_object* associated to the *dashboard*, it cannot be deleted
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let dashboard_id = 4;
        #     this.http.delete(`127.0.0.1/help/dashboards/${dashboard_id}`);
        def destroy
            return respond_with_not_found unless @dashboard

            if @dashboard.destroy
                respond_with_successful
            else
                respond_with_error(@dashboard.errors.full_messages.to_sentence)
            end
        end

        def options
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            respond_with_successful(model.options(current_user, @query))
        end

        def resource_component
            dynamic_info = self.class.dynamic_info
            component_model = dynamic_info[:component_model]

            component_id = params[:component_id].to_sym

            # We verify if the method exists, and if it is in the available component list
            if component_model.respond_to?(component_id) && component_model.component_ids[component_id]
                respond_with_successful(component_model.public_send(component_id, current_user, @query))
            else
                respond_with_not_found()
            end
        end

private

        # @return [void]
        # @description Sets the variable @dashboard. The variable contains the *cloud_object* *dashboard* 
        #     to be handled by the controller action that called this method
        # @example
        #     #suppose params[:id] = 1
        #     puts @dashboard # will display nil
        #     set_dashboard
        #     puts @dashboard # will display an instance of CloudHelp:TicketDashboard
        def set_dashboard
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]
            module_name = dynamic_info[:module_name]

            # When params[:id] is 'default' order of priority is:
            # Main dashboard for user goes first
            # Main dashboard for role goes second
            # Default dashboard goes third
            if params[:id] == "default"
                # Main dashboard for user
                @dashboard = model.find_by(
                    "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id,
                    main: true,
                    user_main_id: current_user.id
                )
                return if @dashboard
                
                # Main dashboard for role
                @dashboard = model.find_by(
                    "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id,
                    roles_id: current_user.roles.first.id
                )
                return if @dashboard

                # Default dashboard
                @dashboard = model.find_by(
                    "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id,
                    default: true
                )
            else
                @dashboard = model.find_by(
                    id: params[:id],
                    "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
                )
            end
        end

        def dashboard_params
            params.require(:dashboard).permit(
                :name,
                :default,
                :roles_id,
                components_attributes: [
                    :id,
                    :name,
                    :component_id,
                    :layout,
                    :index,
                    {query_configuration: {}},
                    {custom_configuration: {}},
                    :_destroy
                ]
            )
        end

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::DashboardsController < CloudObject::DashboardsController
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        #     puts info[:full_module_name] # will print 'CloudHelp'
        #     info[:model].new # will return an instance of CloudHelp::TicketDashboard
        def self.dynamic_info
            module_info = lesli_classname().split("::")


            module_name = module_info[0].sub("Cloud", "").downcase
            
            {
                module_name: module_name,
                full_module_name: module_info[0],
                model: "#{self.name.split("::")[0]}::Dashboard".constantize,
                component_model: "#{self.name.split("::")[0]}::Dashboard::Component".constantize
            }
        end    
    end
end
