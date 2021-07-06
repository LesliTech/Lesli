=begin
Copyright (c) 2021, all rights reserved.

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
class Role::DescriptorAssignmentsController < ApplicationLesliController
    before_action :set_role_descriptor_assignment, only: [:show, :update, :destroy]

    # GET /role/descriptor_assignments
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Role::DescriptorAssignment.index(current_user, @query))
            end
        end
    end

    # GET /role/descriptor_assignments/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_descriptor_assignment
                return respond_with_successful(@role_descriptor_assignment.show(current_user, @query))
            end
        end
    end

    # GET /role/descriptor_assignments/new
    def new
    end

    # GET /role/descriptor_assignments/1/edit
    def edit
    end

    # POST /role/descriptor_assignments
    def create
        role_descriptor_assignment = Role::DescriptorAssignment.new(role_descriptor_assignment_params)
        if role_descriptor_assignment.save
            respond_with_successful(role_descriptor_assignment)
        else
            respond_with_error(role_descriptor_assignment.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /role/descriptor_assignments/1
    def update
        return respond_with_not_found unless @role_descriptor_assignment

        if @role_descriptor_assignment.update(role_descriptor_assignment_params)
            respond_with_successful(@role_descriptor_assignment.show(current_user, @query))
        else
            respond_with_error(@role_descriptor_assignment.errors.full_messages.to_sentence)
        end
    end

    # DELETE /role/descriptor_assignments/1
    def destroy
        return respond_with_not_found unless @role_descriptor_assignment

        if @role_descriptor_assignment.destroy
            respond_with_successful
        else
            respond_with_error(@role_descriptor_assignment.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_role_descriptor_assignment
        @role_descriptor_assignment = current_user.account.role_descriptor_assignments.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_descriptor_assignment_params
        params.require(:role_descriptor_assignment).permit(:id, :name)
    end
end
