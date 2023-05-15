=begin

=end
class SystemDescriptor::PrivilegesController < ApplicationController
    before_action :set_system_descriptor_privilege, only: [:show, :update, :destroy]

    # GET /system_descriptor/privileges
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(SystemDescriptor::Privilege.index(current_user, @query))
            end
        end
    end

    # GET /system_descriptor/privileges/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @system_descriptor_privilege
                return respond_with_successful(@system_descriptor_privilege.show(current_user, @query))
            end
        end
    end

    # GET /system_descriptor/privileges/new
    def new
    end

    # GET /system_descriptor/privileges/1/edit
    def edit
    end

    # POST /system_descriptor/privileges
    def create
        system_descriptor_privilege = SystemDescriptor::Privilege.new(system_descriptor_privilege_params)
        if system_descriptor_privilege.save
            respond_with_successful(system_descriptor_privilege)
        else
            respond_with_error(system_descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /system_descriptor/privileges/1
    def update
        return respond_with_not_found unless @system_descriptor_privilege

        if @system_descriptor_privilege.update(system_descriptor_privilege_params)
            respond_with_successful(@system_descriptor_privilege.show(current_user, @query))
        else
            respond_with_error(@system_descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    # DELETE /system_descriptor/privileges/1
    def destroy
        return respond_with_not_found unless @system_descriptor_privilege

        if @system_descriptor_privilege.destroy
            respond_with_successful
        else
            respond_with_error(@system_descriptor_privilege.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_system_descriptor_privilege
        @system_descriptor_privilege = current_user.account.system_descriptor_privileges.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def system_descriptor_privilege_params
        params.require(:system_descriptor_privilege).permit(:id, :name)
    end
end
