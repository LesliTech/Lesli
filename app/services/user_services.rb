=begin

Copyright (c) 2023, all rights reserved.

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

class UserServices < LesliServices


    # Return a list of users that belongs to the account of the current_user
    # this list is meant to be used in selectors, autocomplets, etc
    def list query=nil, params=nil
        users = current_user.account.users        

        if params[:role].present?
            # add simple quotes to the roles so the sql can manage the query
            roles = params[:role].split(",").map { |role| "'#{role}'" }.join(", ")
            users = users.joins("
                inner join (
                    select
                        ur.users_id, string_agg(r.\"name\", ', ') role_names
                    from user_roles ur
                    join roles r
                        on r.id = ur.roles_id 
                        and r.name in ( #{ roles } )
                    where ur.deleted_at is null
                    group by ur.users_id
                ) roles on roles.users_id = users.id
            ")
        end

        users = users.order(name: :asc)
        .select(
            :id,
            :email,
            :name,
            :alias
        ).as_json
    end


    # @return [Array] Paginated index of users.
    # @description Return a paginated array of users, used mostly in frontend views
    def index query, params

        # sql string to join to user_roles and get all the roles assigned to a user
        sql_string_for_user_roles = "inner join (
            select
                ur.users_id, string_agg(r.\"name\", ', ') role_names
            from user_roles ur
            join roles r
                on r.id = ur.roles_id
            where ur.deleted_at is null
            group by ur.users_id
        ) roles on roles.users_id = users.id"

        # sql string to joing to user_sessions and get all the active sessions of a user
        sql_string_for_user_sessions = "left join (
            select
                max(last_used_at) as last_action_performed_at,
                max(created_at) as last_login_at,
                users_id
            from user_sessions us
            where us.deleted_at is null
            group by(us.users_id)
        ) sessions on sessions.users_id = users.id"

        users = current_user.account.users
        .joins(:detail)
        .joins(sql_string_for_user_roles)
        .joins(sql_string_for_user_sessions)
        .where("category = 'user'")


        if query.dig(:search)
            users = users.where(
                "lower(users.email) like :search or lower(concat(user_details.first_name, ' ', user_details.last_name)) like :search",
                { search: "%#{LC::Sql.sanitize_for_search(query.dig(:search))}" }
            )
        end

        users = users.select(
            :id,
            :active,
            :email,
            "role_names as roles",
            "CONCAT(user_details.first_name, ' ',user_details.last_name) as name",
            "current_sign_in_at as current_signin_at",
            :last_action_performed_at,
            :last_login_at,
            "false as editable"
        )

        return users
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")
    end


    # Creates a query that selects all user information from several tables if CloudLock is present
    def show (user=nil)

        user = user || resource

        return {
            id: user[:id],
            email: user[:email],
            alias: user[:alias],
            active: user[:active],
            created_at: user[:created_at],
            updated_at: user[:updated_at],
            editable_security: current_user && current_user.has_roles?("owner", "sysadmin"),
            roles: user.roles.map { |r| { id: r[:id], name: r[:name], permission_level: r[:object_level_permission]} },
            full_name: user.full_name,
            mfa_enabled: user.mfa_settings[:enabled],
            mfa_method:  user.mfa_settings[:method],
            locale: user.settings.select(:value).find_by(:name => "locale"),
            detail_attributes: {
                title: user.detail[:title],
                salutation: user.detail[:salutation],
                first_name: user.detail[:first_name],
                last_name: user.detail[:last_name],
                telephone: user.detail[:telephone],
                address: user.detail[:address],
                work_city: user.detail[:work_city],
                work_region: user.detail[:work_region],
                work_address: user.detail[:work_address]
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
            :detail_attributes => user_params[:detail_attributes] || {}
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
                    # Search the role assigned
                    role = current_user.account.roles.find_by(id: user_params[:roles_id])
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

            self.resource = user

            begin
                # users created through the administration area does not need to confirm their accounts
                # instead we send a password reset link, so they can have access to the platform
                UserMailer.with(user: user).invitation_instructions.deliver_now
            rescue => exception
                Honeybadger.notify(exception)
                user.logs.create({ description: "user_creation_email_failed " + exception.message })
            end

        else
            self.error(user.errors.full_messages.to_sentence)
        end

        self

    end

    def find id
        self.resource = current_user.account.users.find_by(id: id)
        self
    end
end
