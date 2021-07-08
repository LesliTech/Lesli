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
    before_action :set_role, only: [:index, :create]
    before_action :set_role_descriptor_assignment, only: [:destroy]

    def index        
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_successful(@role.descriptor_assignments)
            }
        end
    end
    
    def create
        role_descriptor_assignment = @role.descriptor_assignments.new(role_descriptor_assignment_params)
        
        if role_descriptor_assignment.save
            respond_with_successful(role_descriptor_assignment)
        else
            respond_with_error(role_descriptor_assignment.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @role_descriptor_assignment

        if @role_descriptor_assignment.destroy
            respond_with_successful
        else
            respond_with_error(@role_descriptor_assignment.errors.full_messages.to_sentence)
        end
    end

    def options
        respond_with_successful(Role::DescriptorAssignment.options(current_user))
    end
    
    private

    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end
    
    def set_role_descriptor_assignment
        set_role 
        
        return respond_with_not_found unless @role 
        
        @role_descriptor_assignment = @role.descriptor_assignments.find_by(id: params[:id])
    end

    def role_descriptor_assignment_params        
        params.require(:role_descriptor_assignment).permit(
            :role_descriptors_id,
            :category
        )
    end
end
