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

    def privileges 
        {
            index: [],
            show: ['Role::DescribersController#index']
        }
    end 

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
                respond_with_pagination(Role.index(current_user, @query))
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

        unless current_user.can_work_with_role?(role)
            return respond_with_error(I18n.t("core.roles.messages_danger_creating_role_object_level_permission_too_high"))
        end

        # check if user can work with that object level permission
        if role.object_level_permission.to_f >= current_user.roles.map(&:object_level_permission).max()
            return respond_with_error(I18n.t("core.roles.messages_danger_creating_role_object_level_permission_too_high"))
        end

        if role.save
            respond_with_successful(role)
            Role::Activity.log_create(current_user, role)
        else
            respond_with_error(role.errors.full_messages.to_sentence)
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

        # Respond with 404 if role was not found
        return respond_with_not_found unless @role

        # check if current user can work with role
        unless current_user.can_work_with_role?(@role)
            return respond_with_error(I18n.t("core.roles.messages_danger_updating_role_object_level_permission_too_high"))
        end

        old_attributes = @role.attributes

        if @role.update(role_params)
            new_attributes = @role.attributes

            respond_with_successful(@role)

            Role::Activity.log_update(current_user, @role, old_attributes, new_attributes)
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

            Role::Activity.log_destroy(current_user, @role)
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end

    def options

        levels = {}

        # get all the different object level permission registered in the roles
        existing_levels = current_user.account.roles
        .select(:object_level_permission)
        .order(object_level_permission: :desc)
        .distinct
        .map { |level| level.object_level_permission }

        # Build the next available object levels
        # basically we need to add the possibles object level permissions between the
        # existing ones
        existing_levels.each_with_index do |level_current, i|

            level_next = 0

            # get the next OLP in the list of the existing roles
            level_next = existing_levels.to_a[i+1] unless existing_levels.to_a[i+1].nil?
            
            # calculate the new next level, basically we get the level right in the middle
            # between the existing levels, example:
            #   1000    existing level
            #    750    new projected level
            #    500    existing level
            level_new = (level_current + level_next) / 2

            # add the levels to the levels object
            levels[level_current] = []

            next if level_next == 0

            levels[level_new] = []

        end

        # Get all the existing roles
        current_user.account.roles
        .select(:id, :name, :object_level_permission)
        .where.not(object_level_permission: nil).each do |role|
            levels[role.object_level_permission] = [] if levels[role.object_level_permission].blank?
            # push the role grouping by the object level permission
            levels[role.object_level_permission].push(role)
        end

        levels_sorted = []

        levels.keys.each do |key|
            levels_sorted.push({
                level: key,
                roles: levels[key]
            })
        end

        respond_with_successful({ :object_level_permissions => levels_sorted })

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
        params.fetch(:role, {}).permit(
            :name,
            :active,
            :only_my_data,
            :default_path,
            :object_level_permission
        )
    end
end
