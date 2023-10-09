=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class UserService < Lesli::ApplicationLesliService


        # Return a list of users that belongs to the account of the current_user
        # this list is meant to be used in selectors, autocomplets, etc
        def list query=nil, params=nil
            #users = current_user.account.users
            users = Lesli::Account.first.users

            if params[:role].present?
                # add simple quotes to the roles so the sql can manage the query
                roles = params[:role].split(",").map { |role| "'#{role}'" }.join(", ")
                users = users.joins("
                    inner join (
                        select
                            ur.users_id, string_agg(r.\"name\", ', ') role_names
                        from user_roles ur
                        join roles r
                            on r.id = ur.role_id 
                            and r.name in ( #{ roles } )
                        where ur.deleted_at is null
                        group by ur.users_id
                    ) roles on roles.users_id = users.id
                ")
            end

            users.order(name: :asc).select(
                :id,
                :email,
                "CONCAT_WS(' ', first_name, last_name) as name",
                :alias
            ).as_json
        end


        # @return [Array] Paginated index of users.
        # @description Return a paginated array of users, used mostly in frontend views
        # TODO: Implement pg_search
        def index query, params

            # sql string to join to user_roles and get all the roles assigned to a user
            sql_string_for_user_roles = "left join (
                select
                    ur.user_id, string_agg(r.\"name\", ', ') rolenames
                from user_roles ur
                join roles r
                    on r.id = ur.role_id
                where ur.deleted_at is null
                group by ur.user_id
            ) roles on roles.user_id = users.id"

            # sql string to joing to user_sessions and get all the active sessions of a user
            sql_string_for_user_sessions = "left join (
                select
                    max(last_used_at) as last_action_performed_at,
                    user_id
                from user_sessions us
                where us.deleted_at is null
                group by(us.user_id)
            ) sessions on sessions.user_id = users.id"

            #users = current_user.account.users
            users = Lesli::Account.first.users
            #.joins(sql_string_for_user_roles)
            #.joins(sql_string_for_user_sessions)
            users = users.page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

            users.select(
                :id,
                "CONCAT(COALESCE(first_name, ''), ' ', COALESCE(last_name, '')) as name",
                :email,
                :active,
                #:rolenames,
                #Date2.new.date_time.db_column("current_sign_in_at"),
                #Date2.new.date_time.db_column("last_action_performed_at")
            )

        end


        # Creates a query that selects all user information from several tables if CloudLock is present
        def show

            user = resource

            return {
                id: user[:id],
                email: user[:email],
                alias: user[:alias],
                active: user[:active],
                full_name: user.full_name,
                salutation: user[:salutation],
                first_name: user[:first_name],
                last_name: user[:last_name],
                telephone: user[:telephone],
                
                #locale: user.settings.select(:value).find_by(:name => "locale"),

                #roles: user.roles.map { |r| { id: r[:id], name: r[:name], permission_level: r[:object_level_permission]} },

                #mfa_enabled: user.mfa_settings[:enabled],
                #mfa_method:  user.mfa_settings[:method],

                created_at: user[:created_at],
                updated_at: user[:updated_at],
                detail_attributes: {
                    title: user.detail[:title],
                #     address: user.detail[:address],
                #     work_city: user.detail[:work_city],
                #     work_region: user.detail[:work_region],
                #     work_address: user.detail[:work_address]
                }
            }
        end

        def create user_params

            # check if request has an email to create the user
            if user_params[:email].blank?
                self.error(I18n.t("core.users.messages_danger_not_valid_email_found"))
            end

            
            # register the new user
            user = User.new({
                :active => true,
                :email => user_params[:email],
                :alias => user_params[:alias] || "",
                :first_name => user_params[:first_name] || "",
                :last_name => user_params[:last_name] || "",
                :telephone => user_params[:telephone] || "",
                #:detail_attributes => user_params[:detail_attributes] || {}
            })



            # assign a random password
            user.password = Devise.friendly_token

            # enrol user to my own account
            user.account = current_user.account

            # users created through the administration area does not need to confirm their accounts
            # instead we send a password reset link, so they can have access to the platform
            #user.confirm

            if user.save

                # if a role is provided to assign to the new user
                # unless user_params[:roles_id].blank?
                #     # check if current user can work with the sent role
                #     if current_user.can_work_with_role?(user_params[:roles_id])
                #         # Search the role assigned
                #         role = current_user.account.roles.find_by(id: user_params[:roles_id])
                #         # assign role to the new user
                #         user.user_roles.create({ role: role })
                #     end
                # end

                # role validation - if new user does not have any role assigned
                # if user.roles.blank?

                #     default_role_id = current_user.account.settings.find_by(:name => "default_role_id")&.value
                #     owner_role_id =  current_user.account.roles.find_by(:name => "owner").id
                #     if default_role_id.present? && default_role_id != owner_role_id
                #         # assign default role
                #         user.user_roles.create({ role:  current_user.account.roles.find_by(:id => default_role_id)})

                #     else
                #         # assign limited role
                #         user.user_roles.create({ role: current_user.account.roles.find_by(:name => "limited") })
                #     end 
                # end

                # saving logs with information about the creation of the user
                # user.logs.create({ title: "user_created_at", description: Date2.new.date_time.to_s })
                # user.logs.create({ title: "user_created_by", description: current_user.email })
                # user.logs.create({ title: "user_created_with_role", description: user.user_roles.first.role.name + " " + user.user_roles.first.role.id.to_s})
                # User.log_activity_create(current_user, user)

                self.resource = user

                begin
                    # users created through the administration area does not need to confirm their accounts
                    # instead we send a password reset link, so they can have access to the platform
                    #UserMailer.with(user: user).invitation_instructions.deliver_now
                rescue => exception
                    #Honeybadger.notify(exception)
                    #user.logs.create({ title: "user_creation_email_failed ", description: exception.message })
                end

            else
                self.error(user.errors.full_messages.to_sentence)
            end

            self

        end

        def update params

            # old_attributes = resource.detail.attributes.merge({
            #     active: resource.active
            # })

            if resource.update(params)
                # new_attributes = resource.detail.attributes.merge({
                #     active: resource.active
                # })
                #resource.log_activity_update(current_user, resource, old_attributes, new_attributes)
            else
                self.error(resource.errors.full_messages.to_sentence)
            end
            
            self
        end


        # force the user to change the password (at next login)
        def request_password

            # expire password
            resource.set_password_as_expired

            resource.logs.create({ title: "request_password", description: "by_user: " + current_user.email })
        end


        # generate a random password for the user
        def password_reset

            # generate random password
            pass = resource.password_reset

            resource.logs.create({ title: "password_reset", description: "by_user: " + current_user.email })

            pass
        end

        def logout
            # delete user active sessions
            resource.sessions.destroy_all

            resource.logs.create({ title: "close_sessions", description: "by_user: " + current_user.email })
        end

        def revoke_access

            # delete user active sessions
            self.logout

            # add delete date to the last active session
            resource.revoke_access

            resource.logs.create({ title: "revoke_access", description: "by_user: " + current_user.email })
        end

        def find id
            #super(current_user.account.users.joins(:detail).find_by(id: id))
            super(current_user.account.users.find_by(id: id))
        end
    end
end
