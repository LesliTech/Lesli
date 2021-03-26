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


# @description User management
class UsersController < ApplicationLesliController
    before_action :set_user, only: [:show, :update, :destroy]

    def list
        respond_to do |format|
            format.json { respond_with_successful(User.list(current_user, @query, params)) }
        end
    end

    # @return [Json] Json that contains a list of all files related to a *cloud_object*
    # @description Retrieves and returns all files associated to a *cloud_object*. The id of the
    #     *cloud_object* is within the *params* attribute
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let ticket_id = 1;
    #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/files`);
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
                    #is_editable: @user.is_editable_by?(current_user)
                })

                respond_with_successful(user)
            }
        end
    end

    def create

        # check if request has an email to create the user
        if user_params[:email].blank?
            respond_with_error("not valid email found")
            return
        end

        # register the new user
        user = User.new({
            :active => true,
            :email => user_params[:email],
            :detail_attributes => user_params[:detail_attributes]
        })

        # assign a random password
        user.password = Devise.friendly_token

        # enrol user to my own account
        user.account = current_user.account


        # users created through the administration area does not need to confirm their accounts
        # instead we send a password reset link, so they can have access to the platform
        user.confirm

        if user.save

            # if a role is provided to assign to the new user
            if not user_params[:roles_id].blank?

                # check if current user can work with the sent role
                if current_user.can_work_with_role?(user_params[:roles_id])

                    # get the requested role to assign to the new user
                    role = current_user.account.roles.find(user_params[:roles_id])

                    # assign role to the new user
                    user.user_roles.create({ role: role })

                end

            end

            # role validation - if new user does not have any role assigned
            if user.roles.blank?

                # assign limited role
                user.user_roles.create({ role: current_user.account.roles.find_by(:name => "limited") })

            end

            # saving logs with information about the creation of the user
            user.logs.create({ description: "user_created_at " + LC::Date.to_string_datetime(LC::Date.datetime) })
            user.logs.create({ description: "user_created_by " + current_user.id.to_s })
            user.logs.create({ description: "user_created_with_role " + user.user_roles.first.roles_id.to_s })

            User.log_activity_create(current_user, user)

            respond_with_successful(user)

            begin
                # users created through the administration area does not need to confirm their accounts
                # instead we send a password reset link, so they can have access to the platform
                UserMailer.with(user: user).invitation_instructions.deliver_now
            rescue => exception
                Honeybadger.notify(exception)
                user.logs.create({ description: "user_creation_email_failed " + exception.message })
            end

        else
            respond_with_error(user.errors.full_messages.to_sentence)
        end

    end

    def update

        # validate that user exists
        return respond_with_not_found unless @user
        #return respond_with_unauthorized unless @user.is_editable_by?(current_user)

        old_attributes = @user.detail.attributes.merge({
            active: @user.active
        })

        if @user.update(user_params)
            new_attributes = @user.detail.attributes.merge({
                active: @user.active
            })

            # return a successful response
            respond_with_successful

            User.log_activity_update(current_user, @user, old_attributes, new_attributes)
        else
            respond_with_error(@user.errors.full_messages.to_sentence)
        end

    end

    def destroy
        return respond_with_not_found unless @user

        if @user.delete
            current_user.logs.create({ session_uuid: nil, description: "deleted_user #{@user.id}-#{@user.full_name} by_user_id: #{current_user.id}" })
            respond_with_successful
          else
            respond_with_error(@user_session.errors.full_messages.to_sentence)
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

        roles = current_user.account.roles.select(:id, :name)

        # only owner can assign any role
        unless current_user.has_roles?("owner")
            roles = roles.where("object_level_permission < ?", (current_user.roles.map{ |r| r[:object_level_permission] }).max)
        end

        respond_with_successful({
            roles: roles,
            salutations: User::Detail.salutations.map {|k, v| {value: k, text: v}},
        })
    end

    def become

        # always should be disabled
        return respond_with_unauthorized

        # Allow only admin to become as user
        return respond_with_unauthorized if current_user.email != "crm.admin@deutsche-leibrenten.de"

        # Search for desire user
        become_user = User.find(params[:id])

        # Return an error if user does not exist
        return respond_with_error "Not valid user found" if become_user.blank?

        # Extrictly save a log when becoming
        current_user.activities.create!({
            users_id: become_user.id,
            owner_id: current_user.id,
            description: "#{current_user.full_name} -> #{become_user.full_name}",
            category: "action_become"
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

        # Integrations cannot be logged out. Since this is equivalent to revoking their access
        return respond_with_error I18n.t("core.users.messages_warning_cannot_log_out_integration") if user.integration?

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

    # Force the user to update his password
    def password

        # get user
        user = User.find(params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error "User not found"
        end

        # expire password
        user.set_password_as_expired

        user.logs.create({ session_uuid: nil, description: "request_password_change by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful

    end

    private

    def user_params
        params.require(:user).permit(
            :active,
            :email,
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
