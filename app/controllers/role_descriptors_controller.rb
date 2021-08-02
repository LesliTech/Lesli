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
class RoleDescriptorsController < ApplicationLesliController
    before_action :set_role_descriptor, only: [:show, :update, :destroy]

    #@return [HTML|JSON] HTML view for listing all role descriptors or a Json that contains a list of all role descriptors
    #    associated to this *account*
    #@description Retrieves and returns all role descriptors associated to a *CloudHouse::Account*. The account
    #    is obtained directly from *current_user*. The HTTP request has to specify
    #    wheter the HTML or the JSON text should be rendered
    #@example
    #    # Executing this controller's action from javascript's frontend
    #    this.http.get(`127.0.0.1/administration/role descriptors`);
    def list 
        respond_to do |format|
            format.json { 
                respond_with_successful(RoleDescriptor.list(current_user, @query)) 
            }
        end
    end
    
    #@return [HTML|JSON] HTML view for listing all role descriptors or a Json that contains a list of all role descriptors
    #    associated to this *account*
    #@description Retrieves and returns all role descriptors associated to a *CloudHouse::Account*. The account
    #    is obtained directly from *current_user*. The HTTP request has to specify
    #    wheter the HTML or the JSON text should be rendered
    #@example
    #    # Executing this controller's action from javascript's frontend
    #    this.http.get(`127.0.0.1/administration/role descriptors`);
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(RoleDescriptor.index(current_user, @query))
            end
        end
    end

    # @return [HTML|Json] HTML view showing the requested role_descriptor or a Json that contains the
    #     information of the role_descriptor. If there is an error, an explanation message is sent
    # @description Retrieves and returns the requested role descriptors. The id of the
    #     role_descriptor is within the *params* attribute of the controller. The HTTP request has to specify
    #     wheter the HTML or the JSON text should be rendered. This is the only method that uses the role_descriptor
    #     code instead of the ID for searching.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 1;
    #     this.http.get(`127.0.0.1/role descriptors/${role_id}`);
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @role_descriptor
                return respond_with_successful(@role_descriptor.show(current_user, @query))
            end
        end
    end

    # @return [HTML] HTML view for creating a new role_descriptor
    # @description returns an HTML view with a form so users can create a new role_descriptor
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.url.go('/role descriptors/new')
    def new
    end
    
    # @return [HTML] HTML view for editing the role_descriptor
    # @description returns an HTML view with a form so users edit an existing role_descriptor
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 3;
    #     this.url.go(`/role descriptors/${role_id}/edit`)
    def edit
    end

    # @return [Json] Json that contains wheter the creation of the role_descriptor was successful or not.
    #     If it is not successful, it returns an error message
    # @description Creates a new role_descriptor associated to the *current_user*'s *account*.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let data = {
    #         role_descriptor: {
    #             name: "Change Request"
    #         }
    #     };
    #     this.http.post('127.0.0.1/administration/role descriptors', data);
    def create
        role_descriptor = current_user.account.role_descriptors.new(role_descriptor_params)
        
        # Validation for name restriction of default descriptors
        if (["owner", "admin", "profile"].include? role_descriptor[:name]) 
            respond_with_error(I18n.t("core.role_descriptors.message_danger_reserved_name"))
        end
        
        if role_descriptor.save
            respond_with_successful(role_descriptor)
            
            RoleDescriptor::Activity.log_create(current_user, role_descriptor)
        else
            respond_with_error(role_descriptor.errors.full_messages.to_sentence)
        end
    end

    # @controller_action_param :name [String] The name of the role_descriptor
    # @return [Json] Json that contains wheter the role_descriptor was successfully updated or not.
    #     If it it not successful, it returns an error message
    # @description Updates an existing role_descriptor associated to the *current_user*'s *account*.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 4;
    #     let data = {
    #         role_descriptor: {
    #             name: "Issue"
    #         }
    #     };
    #     this.http.patch(`127.0.0.1/administration/role_descriptors/${role_id}`, data);
    def update
        return respond_with_not_found unless @role_descriptor

        old_attributes = @role_descriptor.attributes
        
        if @role_descriptor.update(role_descriptor_params)
            new_attributes = @role_descriptor.attributes
            
            respond_with_successful(@role_descriptor.show(current_user, @query))
            
            RoleDescriptor::Activity.log_update(current_user, @role_descriptor, old_attributes, new_attributes)
        else
            respond_with_error(@role_descriptor.errors.full_messages.to_sentence)
        end
    end
    
    # @return [Json] Json that contains wheter the role_descriptor was successfully deleted or not.
    #     If it it not successful, it returns an error message
    # @description Deletes an existing *role_descriptor* associated to the *current_user*'s *account*.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 4;
    #     this.http.delete(`127.0.0.1/administration/role_descriptors/${role_id}`);
    def destroy
        return respond_with_not_found unless @role_descriptor
        return respond_with_error(I18n.t("")) if @role_descriptor.has_roles_assigned?
        
        if @role_descriptor.destroy
            respond_with_successful
            
            RoleDescriptor::Activity.log_destroy(current_user, @role_descriptor)
        else
            respond_with_error(@role_descriptor.errors.full_messages.to_sentence)
        end
    end

    private

    # @return [void]
    # @description Sets the requested user based on the current_users's account
    # @example
    #     # Executing this method from a controller action:
    #     set_role_descriptor
    #     puts @role_descriptor
    #     # This will either display nil or an instance of role_descriptor
    def set_role_descriptor
        @role_descriptor = current_user.account.role_descriptors
        .where.not("role_descriptors.name in (?)", ["admin", "owner", "profile"]) # Add security that the default role_descriptor descriptors don't be edited
        .find_by(id: params[:id])
    end

    # @return [Parameters] Allowed parameters for the role_descriptor
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are detail_attributes: [:name, :active, :object_level_permission]
    # @example
    #     # supose params contains {
    #     #    "role_descriptor": {
    #     #        "name": "Admin",
    #     #        "word": Hello
    #     #    }
    #     #}
    #     filtered_params = role_params
    #     puts filtered_params
    #     # will remove all unpermitted attributes and only print {
    #     #    "name": "Admin",
    #     #}
    def role_descriptor_params
        params.require(:role_descriptor).permit(
            :id, 
            :name, 
            :description,
            :role_descriptors_id
        )
    end
end
