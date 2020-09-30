module CloudObject
    class DashboardsController < ApplicationLesliController
        before_action :set_dashboard, only: [:update, :destroy]

=begin
@return [HTML|JSON] HTML view for listing all dashboards or a Json that contains a list 
    of all dashboards associated to this *account*
@description Retrieves and returns all dashboards associated to a *CloudHelp::Account*. 
    The account is obtained directly from *current_user*. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    this.http.get(`127.0.0.1/help/dashboards`);
=end
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

=begin
@return [HTML|Json] HTML view showing the requested dashboard or a Json that contains the
    information of the dashboard. If there is an error, an explanation message is sent
@description Retrieves and returns the requested dashboard. The id of the 
    dashboard is within the *params* attribute of the controller. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    let dashboard_id = 1;
    this.http.get(`127.0.0.1/help/dashboards/${dashboard_id}`);
=end
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

=begin
@return [HTML] HTML view for creating a new dashboard
@description returns an HTML view with a form so users can create a new dashboard
@example
    # Executing this controller's action from javascript's frontend
    this.url.go('/help/dashboards/new')
=end
        def new
        end
=begin
@return [HTML] HTML view for editing the dashboard
@description returns an HTML view with a form so users edit an existing dashboard
@example
    # Executing this controller's action from javascript's frontend
    let dashboard_id = 3;
    this.url.go(`/help/dashboards/${dashboard_id}/edit`)
=end
        def edit
        end

=begin
@controller_action_param :name [String] The name of the new dashboard
@controller_action_param :default [Boolean] A flag that marks this dashboard as default or not
@controller_action_param :statuses_attributes [Array] Array of hashes, containing the information of the new attributes
@controller_action_param :statuses_attributes.next_states [String] Transitions to the next state. The format is 
    "[dashboard_state_id]|[dashboard_state_id]|..."
@controller_action_param :statuses_attributes.cloud_[module_name]_[cloud_object_name]_dashboard_states_id [Integer]
    The id of the state associated to this detail
@return [Json] Json that contains wheter the creation of the dashboard was successful or not. 
    If it is not successful, it returns an error message
@description Creates a new dashboard associated to the *current_user*'s *account*
@example
# Executing this controller's action from javascript's frontend
    let data = {
        dashboard: {
            name: "Important",
            default: true,
            statuses_attributes: [
                {
                    cloud_help_dashboard_states_id: 4,
                    next_states: "6"
                },{
                    cloud_help_dashboard_states_id: 6,
                    next_states: null
                }
            ]
        }
    };
    this.http.post('127.0.0.1/help/dashboards', data);
=end
        def create
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            model = dynamic_info[:model]

            dashboard = model.new(dashboard_params)
            dashboard["cloud_#{module_name}_accounts_id".to_sym] = current_user.account.id
            dashboard.deletion_protection = false

            if dashboard.save
                respond_with_successful(dashboard)
            else
                respond_with_error(dashboard.errors.full_messages.to_sentence)
            end
        end

=begin
@controller_action_param :name [String] The name of the new dashboard
@controller_action_param :default [Boolean] A flag that marks this dashboard as default or not
@controller_action_param :detail_attributes [Array] Arary of hashes that represent the attributes
    of the dashboard details
@controller_action_param :detail_attributes.id [Integer] The id of the detail
@controller_action_param :detail_attributes.next_states [String] A string of numbers, separated by '|'.
    Each number represents the id of a *CloudObject::Dashboard* and creates a valid transition. 
    A valid transition is a transition from one detail that has a state in its *next_states* attribute 
    to another detail, that has that state in its *dashboard_state_id* attribute
@controller_action_param :detail_attributes._dashboard_state_id [Integer]
    The id of the state associated to this dashboard detail
@return [Json] Json that contains wheter the dashboard was successfully updated or not. 
    If it it not successful, it returns an error message
@description Updates an existing dashboard associated to the *current_user*'s *account*.
@example
# Executing this controller's action from javascript's frontend
let dashboard_id = 4;
let data = {
    dashboard: {
        name: "Sales Dashboard",
        statuses_attributes: [
            {
                id: 1,
                next_states: '56|57',
                dashboard_states_id: 55
            }, {
                id: 4,
                next_states: null,
                dashboard_states_id: 56
            }, {
                id: 5,
                next_states: null,
                dashboard_states_id: 57
            }
        ]
    }
};
this.http.put(`127.0.0.1/help/dashboards/${dashboard_id}`, data);
=end
        def update
            return respond_with_not_found unless @dashboard

            if @dashboard.update(dashboard_params)
                respond_with_successful(@dashboard)
            else
                respond_with_error(@dashboard.errors.full_messages.to_sentence)
            end
        end

=begin
@return [Json] Json that contains wheter the dashboard was successfully deleted or not. 
    If it it not successful, it returns an error message
@description Deletes an existing *dashboard* associated to the *current_user*'s *account*.
    Since the dashboard has details, these are also deleted. However, if there
    is an existing *cloud_object* associated to the *dashboard*, it cannot be deleted
@example
    # Executing this controller's action from javascript's frontend
    let dashboard_id = 4;
    this.http.delete(`127.0.0.1/help/dashboards/${dashboard_id}`);
=end
        def destroy
            return respond_with_not_found unless @dashboard

            if @dashboard.destroy
                respond_with_successful
            else
                respond_with_error(@dashboard.errors.full_messages.to_sentence)
            end
        end

=begin
@description Retrieves a list of possible transitions the the *cloud_object*, depending on the *state* they are actually in.
@example
    # Executing this controller's action from javascript's frontend
    let ticket_id = 6
    this.http.get(`127.0.0.1/help/options/dashboards/ticket/${ticket_id}`).then(response => {
        if( response.successful ){
            console.log(JSON.stringify(response.data))
            # This will print something similar to
            #[
            #    {"id":2,"name":"closed","dashboard_detail_id":8},
            #    {"id":3,"name":"In progress","dashboard_detail_id":9}
            #]
            # where "id" is the id of the wokflow state
        }
    });
=end
        def transition_options
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            full_module_name = dynamic_info[:full_module_name]
            cloud_object_model = "#{full_module_name}::#{params[:cloud_object_name].camelize}".constantize

            cloud_object = cloud_object_model.find_by(
                id: params[:cloud_object_id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )

            return respond_with_not_found unless cloud_object

            respond_with_successful(cloud_object.status.next_dashboard_statuses(current_user))
        end

private

=begin
@return [void]
@description Sets the variable @dashboard. The variable contains the *cloud_object* *dashboard* 
    to be handled by the controller action that called this method
@example
    #suppose params[:id] = 1
    puts @dashboard # will display nil
    set_dashboard
    puts @dashboard # will display an instance of CloudHelp:TicketDashboard
=end
        def set_dashboard
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]
            module_name = dynamic_info[:module_name]

            @dashboard = model.find_by(
                id: params[:id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

        def dashboard_params
            params.require(:dashboard).permit(
                :name,
                :default,
                components_attributes: [
                    :name,
                    :component_id,
                    :layout,
                    :index,
                    :configuration
                ]
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::DashboardsController < CloudObject::DashboardsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:full_module_name] # will print 'CloudHelp'
    info[:model].new # will return an instance of CloudHelp::TicketDashboard
=end
        def self.dynamic_info
            module_info = lesli_classname().split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            
            {
                module_name: module_name,
                full_module_name: module_info[0],
                model: "#{module_info[0]}::Dashboard".constantize
            }
        end    
    end
end
