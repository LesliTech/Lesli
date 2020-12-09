=begin
<% license = File::expand_path('../../../../../license', __FILE__) %>
<%= File.read(license).to_s.force_encoding("ASCII-8BIT") %>
=end
<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationLesliController
    before_action :set_<%= singular_table_name %>, only: [:update, :destroy]

    # GET <%= route_url %>
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(<%= class_name %>.index(current_user, @query))
            end
        end
    end

    # GET <%= route_url %>/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                set_<%= singular_table_name %>
                return respond_with_not_found unless @<%= singular_table_name %>

                return respond_with_successful(@<%= singular_table_name %>.show(current_user, @query))
                
            end
        end
    end

    # GET <%= route_url %>/new
    def new
    end

    # GET <%= route_url %>/1/edit
    def edit
    end

    # POST <%= route_url %>
    def create
        <%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
        if <%= singular_table_name %>.save
            respond_with_successful(<%= singular_table_name %>.show(current_user, query)
        else
            respond_with_error(<%= singular_table_name %>.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT <%= route_url %>/1
    def update
        return respond_with_not_found unless @<%= singular_table_name %>

        if @<%= singular_table_name %>.update(<%= singular_table_name %>_params)
            respond_with_successful(@<%= singular_table_name %>.show(current_user, query))
        else
            respond_with_error(@<%= singular_table_name %>.errors.full_messages.to_sentence)
        end
    end

    # DELETE <%= route_url %>/1
    def destroy
        return respond_with_not_found unless @<%= singular_table_name %>

        if @<%= singular_table_name %>.destroy
            respond_with_successful
        else
            respond_with_error(@<%= singular_table_name %>.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a list of trusted parameters through.
    def <%= "#{singular_table_name}_params" %>
    <%- if attributes_names.empty? -%>
        params.fetch(:<%= singular_table_name %>, {})
    <%- else -%>
        params.require(:<%= singular_table_name %>).permit(<%= permitted_params %>)
    <%- end -%>
    end
end
<% end -%>
