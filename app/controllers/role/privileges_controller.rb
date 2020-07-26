=begin
Lesli
Copyright (c) 2020, Lesli Technologies, S. A.
All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.
LesliCloud - Your Smart Business Assistant
Powered by https://www.lesli.tech
Building a better future, one line of code at a time.
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class Role::PrivilegesController < ApplicationController
    before_action :set_role_privilege, only: [:show, :update, :destroy]
    before_action :set_role, only: [:index]

    # GET role/:id/privileges
    # @return [Json] This return a Json with all the privileges
    # @description Returns with a respond_with_successful all the privileges of a specific 
    #         role using the role_id
    # @example
    #     #Executing this controller's action from javascript's frontend
    #     let role_id = 1;
    #     this.http.get(`localhost:3000/roles/${this.role_id}/privileges.json`)
    def index
        respond_to do |format|
            format.json {
                respond_with_successful(Role::Privilege.index(@role)) 
            }
        end
    end

    def show
    end

    def new
    end

    def edit
    end

    # POST roles/:id/privileges
    # @controller_action_param :grant_object [String] The privilege grant_object is saved in privileges
    # @return [Json] Json that contains wheter the creation of an action was successful or not. 
    #         If it is not successful, it returns an error message
    # @description Role privileges will be created
    # @example
    # #Executing this controller's action from javascript's frontend
    # let role_id = 1
    # data = {
    #     grant_object: "DeutscheLeibrente/Roles",
    #     grant_index: true
    # };
    # this.http.post(`localhost:3000/roles/${this.role_id}/privileges`, data)
    def create
        @role_privilege = Role::Privilege.new(role_privilege_params)
        @role_privilege.user = current_user

        if @role_privilege.save
            respond_with_successful(@role_privilege)
        else
            respond_with_error(@role_privilege.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT roles/:id/privileges/:id_privilege
    # @controller_action_param :grant_object [String] The grant_object is updated in privileges
    # @return [Json] Json that contains wheter the updated of an action was successful or not. 
    #             If it is not successful, it returns an error message
    # @description Role privileges will be updated
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 1
    #     data = {
    #         id: 5
    #         grant_object: "Admin",
    #         grant_index: true
    #     };
    #     this.http.put(`localhost:3000/roles/${this.role_id}/privileges/${this.role_privilege_id}`, data)
    def update
        return respond_with_not_found unless @role_privilege

        if @role_privilege.update(role_privilege_params)
            respond_with_successful(@role_privilege)
        else
            respond_with_error(@role_privilege.errors.full_messages.to_sentence)
        end
    end

    # DESTROY roles/:id/privileges/:id_privilege
    # @return [Json] Json that contains whether privileges were successfully deleted or not. If it it 
    #         not successful, it returns an error message.
    # @description Delete privileges using the privilege id.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 1;
    #     let role_privilege_id = 1;
    #     this.http.delete(`localhost:3000/roles/${this.role_id}/privileges/${this.role_privilege_id}`)
    def destroy
        return respond_with_not_found unless @role_privilege
        
        if @role_privilege.destroy
            respond_with_successful
        else
            respond_with_error(@role_privilege.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT roles/:id/privileges/:id_privilege
    # @controller_action_param :grant_object [String] The grant_object is updated in privileges
    # @return [Json] Json that contains wheter the updated of an action was successful or not. 
    #             If it is not successful, it returns an error message
    # @description Role privileges will be updated
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 1
    #     data = {
    #         id: 5
    #         grant_object: "Admin",
    #         grant_index: true
    #     };
    #     this.http.put(`localhost:3000/roles/${this.role_id}/privileges/${this.role_privilege_id}`, data)
    def update_by_module
        set_role

        return respond_with_not_found unless @role
        
        if @role.privileges.where(id: params[:ids]).update_all(["#{params[:column]} = ?", params[:value]])
            respond_with_successful()
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end
    
    private

    # set_role_privilege
    # @return [void]
    # @description Sets the variable @role_privilege. The variable contains the data
    #         of the role.
    # @example
    #     #suppose params[:id] = 5
    #     puts @role_privilege # will display nil
    #     set_role_privilege
    #     puts @role_privilege # will display all the data
    def set_role_privilege
        set_role
        @role_privilege = @role.privileges.find_by(id: params[:id])
    end

    def set_role
        @role = current_user.account.roles.find_by(id: params[:role_id])
    end

    # Get role_privilege_params
    # @return [Parameters] Allowed parameters for the action
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    # Allowed params are: 
    #     :id, :grant_object, :cloud_lock_roles_id, :grant_index, 
    #     :grant_create, :grant_new, :grant_edit, :grant_show, 
    #     :grant_update, :grant_destroy, :grant_options, 
    #     :deleted_at, :created_at, :updated_at
    # @example
    # supose params contains {
    #    "privilege_Action": {
    #        "id": 1,
    #        "grant_object": "DeutscheLeibrente/Roles",
    #        "cloud_lock_roles_id": 15  
    #        "personal_email_address_test_false": "testing@lesli.com"
    #    }
    # }
    # action_params = role_privilege_params
    # puts action_params
    # will remove personal_email_address_test_false field and only print {
    #    "privilege_Action": {
    #        "id": 1,
    #        "grant_object": "DeutscheLeibrente/Roles",
    #        "cloud_lock_roles_id": 15         
    #    }
    #}
    def role_privilege_params
        params.require(:privilege).permit(
            :grant_object, 
            :cloud_lock_roles_id,
            :grant_index, 
            :grant_create, 
            :grant_new,     
            :grant_edit, 
            :grant_show, 
            :grant_update, 
            :grant_destroy, 
            :grant_options, 
            :grant_resources,
            :grant_search,
            :created_at, 
            :updated_at
        )   
    end
end
