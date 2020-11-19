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

class UsersController < ApplicationLesliController
    before_action :set_user, only: [:show, :update]
    
    def index
        respond_to do |format|
            format.html { }
            format.json { respond_with_successful(User.index(current_user, @query, params)) }
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json {
                
                return respond_with_not_found unless @user

                user = @user.show(current_user).merge({
                    is_editable: @user.is_editable_by?(current_user)
                })

                respond_with_successful(user)
            }
        end
    end

    def create
        user = User.new(user_params)
        user.password = Devise.friendly_token
        user.account = current_user.account
        user.confirm

        if user.role.blank?
            user.role = current_user.account.roles.joins(:detail).where("role_details.name = 'limited'").first
        end

        if user.save
            respond_with_successful(user)
            User.send_password_reset(user)
        else
            respond_with_error(user.errors.full_messages.to_sentence)
        end
    end

    def update 

        # validate that user exists
        return respond_with_not_found unless @user
        return respond_with_unauthorized unless @user.is_editable_by?(current_user)

        # only owner can assign owner role
        if user_params["roles_id"]
            role_name = Role.find(user_params["roles_id"]).detail.name
            return responseWithUnauthorized if role_name == "owner" && !current_user.is_role?("owner")
        end

        # only owners and admins can assign high level roles
        user_params.delete("roles_id") if not current_user.is_role?("owner", "admin")

        if (@user.active != user_params[:active])
            @user.activities.create({ description: "update_user", field_name: "active", value_from: @user.active.to_s, value_to: user_params[:active].to_s, owner_id: current_user.id })
        end 

        if @user.update(user_params)
            
            # return a successful response 
            respond_with_successful
            
        else
            respond_with_error(@user.errors.full_messages.to_sentence)
        end

    end

    # @return [void]
    # @description Sets the requested user based on the current_users's account
    # @example
    #     # Executing this method from a controller action:
    #     set_user
    #     puts @user
    #     # This will either display nil or an instance of Account::User
    def set_user
        @user = current_user.account.users.find_by(id: params[:id])
    end

    def options
        options = {
            roles: current_user.account.roles.joins(:detail)
                    .select("
                        roles.id as value, 
                        role_details.name as text
                    "),
            salutations: User::Detail.salutations.map {|k, v| {value: k, text: v}},
        }

        respond_with_successful(options)
    end

    def become

        # Allow only admin to become as user
        return respond_with_unauthorized if current_user.email != "crm.admin@deutsche-leibrenten.de"

        # Search for desire user
        become_user = User.find(params[:id])

        # Return an error if user does not exist
        return respond_with_error "Not valid user found" if become_user.blank?

        # Extrictly save a log when becoming 
        current_user.activities.create({
            request_controller: controller_path,
            request_method: request.method,
            request_action: action_name, 
            request_url: request.original_fullpath, 
            description: "becoming from #{current_user.email} to #{become_user.email}"
        })

        # Sign in as the becoming user
        sign_in(:user, become_user)

        # Response successful
        respond_with_successful(current_user) 
        
    end

    def logout

        # get user
        user = User.find(params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error "User not found"
        end

        # delete user active sessions
        user.close_session

        user.logs.create({ session_uuid: nil, description: "close_session by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful

    end

    def lock

        # get user
        user = User.find(params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error "User not found"
        end

        # delete user active sessions
        user.close_session

        # add delete date to the last active session
        user.revoke_access

        user.logs.create({ session_uuid: nil, description: "revoke_access by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful

    end

    def password

        # get user
        user = User.find(params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error "User not found"
        end

        # expire password
        user.request_password_change

        user.logs.create({ session_uuid: nil, description: "request_password_change by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful

    end

    private
    
    def user_params
        params.require(:user).permit(
            :email,
            :active,
            :roles_id,
            detail_attributes: [
                :first_name,
                :last_name,
                :title, 
                :salutation, 
                :telephone, 
                :address, 
                :work_city, 
                :work_region, 
                :work_address
            ]
        )
    end
    
end
