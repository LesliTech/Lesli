=begin

Copyright (c) 2022, all rights reserved.

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

    def privileges
        {
            index: ['show', 'list'],
            new: [],
            show: ['index', 'list'],
            edit: [],
            email: [],
        }
    end

    def list
        respond_to do |format|
            format.json {

                # Keep compatibility with DeutscheLeibrenten
                if defined?(DeutscheLeibrenten)
                    respond_with_successful(User.list(current_user, @query, params))
                end

                # Lesli v3
                if !defined?(DeutscheLeibrenten)
                    respond_with_successful(User.list(current_user, @query, params))
                end

            }
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
            format.json {
                users = User.index(current_user, @query, params)

                return respond_with_pagination(users, (users.map { |user|

                    # last time user use the login form to access the platform
                    last_sign_in_at = LC::Date.distance_to_words(user[:current_sign_in_at])

                    # last action the user perform an action into the system
                    last_action_performed_at = LC::Date.distance_to_words(user["last_action_performed_at"]) if not user["last_action_performed_at"].blank?

                    # check if user has an active session
                    session = user["last_login_at"].blank? ? false : true

                    {
                        id: user[:id],
                        name: user[:name],
                        email: user[:email],
                        category: user[:category],
                        last_sign_in_at: last_sign_in_at,
                        active: user[:active],
                        roles: user[:roles],
                        last_activity_at: last_action_performed_at,
                        session_active: session
                    }
                }))
            }
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

        LC::Debug.msg(user_params[:roles_id])

        # check if request has an email to create the user
        if user_params[:email].blank?
            respond_with_error(I18n.t("core.users.messages_danger_not_valid_email_found"))
            return
        end

        # register the new user
        user = User.new({
            :active => true,
            :email => user_params[:email],
            :alias => user_params[:alias],
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
            unless user_params[:roles_id].blank?

                # check if current user can work with the sent role
                if current_user.can_work_with_role?(user_params[:roles_id])
                    # assign role to the new user
                    user.user_roles.create({ id: user_params[:roles_id] })
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
            respond_with_successful(@user)

            User.log_activity_update(current_user, @user, old_attributes, new_attributes)
        else
            respond_with_error(@user.errors.full_messages.to_sentence)
        end

    end

    def destroy
        return respond_with_not_found unless @user

        if @user.delete
            current_user.logs.create({ description: "deleted_user #{@user.id}-#{@user.full_name} by_user_id: #{current_user.id}" })
            respond_with_successful(@user)
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

        roles = current_user.account.roles.select(:id, :name, :object_level_permission)

        # only owner can assign any role
        unless current_user.has_roles?("owner")
            roles = roles.where("object_level_permission < ?", (current_user.roles.map{ |r| r[:object_level_permission] }).max)
        end

        respond_with_successful({
            roles: roles,
            regions: current_user.account.locations.where(level: "region"),
            salutations: User::Detail.salutations.map {|k, v| {value: k, text: v}},
            locales: Rails.application.config.lesli.dig(:configuration, :locales_available),
            mfa_methods: Rails.application.config.lesli.dig(:configuration, :mfa_methods)
        })

    end

    def become

        # always should be disabled
        if Rails.configuration.lesli_settings["security"]["enable_becoming"] != true
            return respond_with_unauthorized
        end

        # Allow only sysadmin to become as user
        return respond_with_unauthorized if current_user.email != Rails.application.config.lesli.dig(:account, :user, :email) # sysadmin user

        # Search for desire user
        becoming_user = User.find(params[:id])

        # Return an error if user does not exist
        return respond_with_error I18n.t("core.shared.messages_warning_user_not_found") if becoming_user.blank?

        # Extrictly save a log when becoming
        current_user.activities.create!({
            users_id: becoming_user.id,
            owner_id: current_user.id,
            description: "#{current_user.full_name} -> #{becoming_user.full_name}",
            category: "action_become"
        })

        # Sign in as the becoming user
        sign_in(:user, becoming_user)

        # Create a new session for the becoming user
        becoming_session = becoming_user.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_source => "become_session",
            :last_used_at => LC::Date.now,
            :expiration_at => 60.minutes.from_now
        })

        # assign the session of the becomer user to the becoming user
        session[:user_session_id] = becoming_session[:id]

        # Response successful
        respond_with_successful([current_user, becoming_user])

    end

    # this method is going to close all the open user sessions
    def logout

        # get user
        user = User.find(params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error I18n.t("core.shared.messages_warning_user_not_found")
        end

        # Integrations cannot be logged out. Since this is equivalent to revoking their access
        return respond_with_error I18n.t("core.users.messages_warning_cannot_log_out_integration") if user.integration?

        # delete user active sessions
        sessions_count = user.sessions.delete_all

        user.logs.create({ description: "close_session by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful sessions_count

    end

    def lock

        # get user
        user = User.find_by(id: params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error I18n.t("core.shared.messages_warning_user_not_found")
        end

        # delete user active sessions
        user.close_session

        # add delete date to the last active session
        user.revoke_access

        user.logs.create({ description: "revoke_access by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful

    end

    # Force the user to update his password
    def password

        # get user
        user = User.find_by(id: params[:id])

        # check if user exist
        if user.blank?
            return respond_with_error I18n.t("core.shared.messages_warning_user_not_found")
        end

        # expire password
        user.set_password_as_expired

        user.logs.create({ description: "request_password_change by_user_id: " + current_user.id.to_s })

        # Response successful
        respond_with_successful

    end

    # Resets the user email
    def email

        user = current_user.account.users.find_by(id: params[:id])

        if user.blank? || user.id != current_user.id
            return respond_with_not_found
        end

        if params[:user][:email]
            user.update(email: params[:user][:email])
        end

        user.logs.create({ description: "changed_email_address_id: " + current_user.id.to_s })

        respond_with_successful(params[:user][:email])
    end

    private

    def user_params
        params.require(:user).permit(
            :active,
            :email,
            :alias,
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
