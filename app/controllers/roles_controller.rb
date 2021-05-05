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

class RolesController < ApplicationLesliController
    before_action :set_role, only: [:show, :update, :destroy]

    #@return [HTML|JSON] HTML view for listing all roles or a Json that contains a list of all roles
    #    associated to this *account*
    #@description Retrieves and returns all roles associated to a *CloudHouse::Account*. The account
    #    is obtained directly from *current_user*. The HTTP request has to specify
    #    wheter the HTML or the JSON text should be rendered
    #@example
    #    # Executing this controller's action from javascript's frontend
    #    this.http.get(`127.0.0.1/house/roles`);
    def list
        respond_to do |format|
            format.json { respond_with_successful(Role.list(current_user, @query)) }
        end
    end

    #@return [HTML|JSON] HTML view for listing all roles or a Json that contains a list of all roles
    #    associated to this *account*
    #@description Retrieves and returns all roles associated to a *CloudHouse::Account*. The account
    #    is obtained directly from *current_user*. The HTTP request has to specify
    #    wheter the HTML or the JSON text should be rendered
    #@example
    #    # Executing this controller's action from javascript's frontend
    #    this.http.get(`127.0.0.1/house/roles`);
    def index
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_successful(Role.index(current_user, @query))
            }
        end
    end

    # @return [HTML|Json] HTML view showing the requested role or a Json that contains the
    #     information of the role. If there is an error, an explanation message is sent
    # @description Retrieves and returns the requested roles. The id of the
    #     role is within the *params* attribute of the controller. The HTTP request has to specify
    #     wheter the HTML or the JSON text should be rendered. This is the only method that uses the role
    #     code instead of the ID for searching.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 1;
    #     this.http.get(`127.0.0.1/roles/${role_id}`);
    def show
        respond_to do |format|
            format.html {  }
            format.json {
                return respond_with_not_found unless @role
                respond_with_successful(@role.show)
            }
        end
    end

    # @return [HTML] HTML view for creating a new role
    # @description returns an HTML view with a form so users can create a new role
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     this.url.go('/roles/new')
    def new
    end

    # @return [HTML] HTML view for editing the role
    # @description returns an HTML view with a form so users edit an existing role
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 3;
    #     this.url.go(`/roles/${role_id}/edit`)
    def edit
    end

    # @return [Json] Json that contains wheter the creation of the role was successful or not.
    #     If it is not successful, it returns an error message
    # @description Creates a new role associated to the *current_user*'s *account*.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let data = {
    #         role: {
    #             name: "Change Request"
    #         }
    #     };
    #     this.http.post('127.0.0.1/house/roles', data);
    def create

        role = current_user.account.roles.new(role_params)

        # check if user can work with that object level permission
        if role.object_level_permission >= current_user.roles.map(&:object_level_permission).max()
            respond_with_error("object_level_permission_too_high")
            return
        end

        if role.save
            respond_with_successful(role)

            Role.log_activity_create(current_user, role)

            role.initialize_role_privileges
        else
            respond_with_error(role.errors.full_messages)
        end
    end

    # @controller_action_param :name [String] The name of the role
    # @return [Json] Json that contains wheter the role was successfully updated or not.
    #     If it it not successful, it returns an error message
    # @description Updates an existing role associated to the *current_user*'s *account*.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 4;
    #     let data = {
    #         role: {
    #             name: "Issue"
    #         }
    #     };
    #     this.http.patch(`127.0.0.1/roles/${role_id}`, data);
    def update
        return respond_with_not_found unless @role

        user_role_level_max = current_user.roles.map(&:object_level_permission).max()

        # check if user can work with that object level permission
        if @role.object_level_permission > user_role_level_max
            return respond_with_error("object_level_permission_too_high")
        end

        # if user tries to change level of a role with a highest level he can work with
        if !role_params[:object_level_permission].blank?
            if role_params[:object_level_permission] >= user_role_level_max
                return respond_with_error("object_level_permission_too_high")
            end
        end

        old_attributes = @role.attributes

        if @role.update(role_params)
            new_attributes = @role.attributes

            respond_with_successful(@role)

            Role.log_activity_update(current_user, @role, old_attributes, new_attributes)
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end

    # @return [Json] Json that contains wheter the role was successfully deleted or not.
    #     If it it not successful, it returns an error message
    # @description Deletes an existing *role* associated to the *current_user*'s *account*.
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let role_id = 4;
    #     this.http.delete(`127.0.0.1/roles/${role_id}`);
    def destroy
        return respond_with_not_found unless @role

        return respond_with_error(I18n.t("core.roles.messages_danger_users_assigned_validation")) if @role.has_users?

        if @role.destroy
            respond_with_successful

            Role.log_activity_destroy(current_user, @role)
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end


    def options
        respond_with_successful()
    end

    private

    # @return [void]
    # @description Sets the requested user based on the current_users's account
    # @example
    #     # Executing this method from a controller action:
    #     set_role
    #     puts @role
    #     # This will either display nil or an instance of Role
    def set_role
        @role = current_user.account.roles.find_by(id: params[:id])
    end

    # @return [Parameters] Allowed parameters for the role
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are detail_attributes: [:name, :active, :object_level_permission]
    # @example
    #     # supose params contains {
    #     #    "role": {
    #     #        "name": "Admin",
    #     #        "word": Hello
    #     #    }
    #     #}
    #     filtered_params = role_params
    #     puts filtered_params
    #     # will remove all unpermitted attributes and only print {
    #     #    "name": "Admin",
    #     #}
    def role_params
        params.require(:role).permit(
            :name,
            :active,
            :only_my_data,
            :default_path,
            :object_level_permission
        )
    end
end
