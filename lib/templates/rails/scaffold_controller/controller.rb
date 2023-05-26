=begin
<%= File.read(Pathname.new(LESLI_ROOT).join("lesli.txt")).to_s.force_encoding("ASCII-8BIT") %>=end

<% if namespaced? -%>

require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
    before_action :set_<%= singular_table_name %>, only: [:show, :update, :destroy]

    # GET <%= route_url %>/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(<%= class_name %>Services.new(current_user, query).list)
            end
        end
    end

    # GET <%= route_url %>
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(<%= class_name %>Services.new(current_user, query).index)
            end
        end
    end

    # GET <%= route_url %>/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@<%= singular_table_name %>.show)
            end
        end
    end

    # GET <%= route_url %>/new
    def new
    end

    # GET <%= route_url %>/:id/edit
    def edit
    end

    # POST <%= route_url %>
    def create
        <%= singular_table_name %> = <%= class_name %>Services.new(current_user, query).create(<%= singular_table_name %>_params)
        if <%= singular_table_name %>.successful?
            respond_with_successful(<%= singular_table_name %>.result)
        else
            respond_with_error(<%= singular_table_name %>.errors)
        end
    end

    # PATCH/PUT <%= route_url %>/:id
    def update
        @<%= singular_table_name %>.update(<%= singular_table_name %>_params)

        if @<%= singular_table_name %>.successful?
            respond_with_successful(@<%= singular_table_name %>.result)
        else
            respond_with_error(@<%= singular_table_name %>.errors)
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
        @<%= singular_table_name %> = <%= class_name %>Services.new(current_user, query).find(params[:id])
        return respond_with_not_found unless @<%= singular_table_name %>.found?
    end

    # Only allow a list of trusted parameters through.
    def <%= "#{singular_table_name}_params" %>
    <%- if attributes_names.empty? -%>
        params.require(:<%= singular_table_name %>).permit(:id, :name)
    <%- else -%>
        params.require(:<%= singular_table_name %>).permit(<%= permitted_params %>)
    <%- end -%>
    end
end
<% end -%>
