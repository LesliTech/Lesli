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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class RolesController < ApplicationController    
    before_action :set_role, only: [:update, :destroy]

    def index
        respond_to do |format|
            format.html { }
            format.json {
                query_params = request.query_parameters
                roles = Role.index(current_user, query_params)

                respond_with_successful(roles) 
            }
        end
    end

    def show
        respond_to do |format|
            format.html {  }
            format.json { 
                set_role

                return respond_with_not_found unless @role
                
                @role = @role.show
                respond_with_successful(@role) 
            }
        end
    end

    def new
    end

    def edit
    end

    def create
        role = Role.new(role_params)
        role.account = current_user.account

        if role.save
            respond_with_successful(role)
        else
            respond_with_error(role.errors.full_messages)
        end
    end

    def update
        return respond_with_not_found unless @role
        
        if @role.update(role_params)
            respond_with_successful(@role)
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @role
        
        if @role.destroy
            respond_with_successful
        else
            respond_with_error(@role.errors.full_messages.to_sentence)
        end
    end

    def restore_default_privileges
        set_role
        return respond_with_not_found unless @role

        privilege_defaults = @role.privilege_defaults
        privilege_defaults.each do |privilege_default|
            privilege = @role.privileges.find_by(grant_object: privilege_default.grant_object)
            unless privilege.blank?
                privilege.update(
                    grant_index: privilege_default.grant_index,
                    grant_create: privilege_default.grant_create,
                    grant_new: privilege_default.grant_new,
                    grant_options: privilege_default.grant_options,
                    grant_edit: privilege_default.grant_edit,
                    grant_update: privilege_default.grant_update,
                    grant_show: privilege_default.grant_show,
                    grant_destroy: privilege_default.grant_destroy,
                    grant_resources: privilege.grant_resources,
                    grant_search: privilege.grant_search
                )
            end
        end

        respond_with_successful
    end

    def update_default_privileges
        set_role
        return respond_with_not_found unless @role

        privileges = @role.privileges
        privileges.each do |privilege|
            privilege_default = @role.privilege_defaults.find_by(grant_object: privilege.grant_object)
            unless privilege_default.blank?
                privilege_default.update(
                    grant_index: privilege.grant_index,
                    grant_create: privilege.grant_create,
                    grant_new: privilege.grant_new,
                    grant_options: privilege.grant_options,
                    grant_edit: privilege.grant_edit,
                    grant_update: privilege.grant_update,
                    grant_show: privilege.grant_show,
                    grant_destroy: privilege.grant_destroy,
                    grant_resources: privilege.grant_resources,
                    grant_search: privilege.grant_search
                )
            end
        end

        respond_with_successful
    end

    private

    def set_role
        @role = current_user.account.roles.find_by(id: params[:id])
    end

    def role_params
        params.require(:role).permit(
            detail_attributes: [
                :name,
                :active
            ]
        )
    end
end
