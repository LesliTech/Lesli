
class SystemDescriptorsController < ApplicationController
    before_action :set_descriptor, only: [:show, :update]

    # GET /descriptors/list.json
    def list
        respond_with_successful(Descriptor.list(current_user, @query))
    end

    # GET /descriptors
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(SystemDescriptor.new(current_user, @query).index)
            end
        end
    end

    # GET /descriptors/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @descriptor
                return respond_with_successful(@descriptor.show(current_user, @query))
            end
        end
    end

    # POST /descriptor
    def create
        descriptor = current_user.account.descriptors.new(descriptor_params)
        descriptor.account = current_user.account

        if descriptor.save
            respond_with_successful(descriptor)
        else
            respond_with_error(descriptor.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /descriptor/1
    def update
        old_attributes = @descriptor.attributes

        if @descriptor.update(descriptor_params)
            new_attributes = @descriptor.attributes
            respond_with_successful(@descriptor)
        else
            respond_with_error(@descriptor.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_system_descriptor
        @system_descriptor = current_user.account.system_descriptors.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def system_descriptor_params
        params.require(:system_descriptor).permit(:id, :name, :description, :descriptors_id)
    end
end
