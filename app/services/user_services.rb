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

class UserServices < ApplicationLesliServices


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

        users.order(name: :asc).select(
            :id,
            :email,
            :name,
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
                ur.users_id, string_agg(r.\"name\", ', ') rolenames
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
                users_id
            from user_sessions us
            where us.deleted_at is null
            group by(us.users_id)
        ) sessions on sessions.users_id = users.id"

        users = current_user.account.users
        .joins(sql_string_for_user_roles)
        .joins(sql_string_for_user_sessions)
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

        users.select(
            :id,
            "CONCAT(COALESCE(first_name, ''), ' ', COALESCE(last_name, '')) as name",
            :email,
            :active,
            :rolenames,
            Date2.new.date_time.db_column("current_sign_in_at"),
            Date2.new.date_time.db_column("last_action_performed_at")
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
            
            locale: user.settings.select(:value).find_by(:name => "locale"),

            roles: user.roles.map { |r| { id: r[:id], name: r[:name], permission_level: r[:object_level_permission]} },

            mfa_enabled: user.mfa_settings[:enabled],
            mfa_method:  user.mfa_settings[:method],

            created_at: user[:created_at],
            updated_at: user[:updated_at],
            
            detail_attributes: {
                title: user.detail[:title],
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
            :first_name => user_params[:first_name] || "",
            :last_name => user_params[:last_name] || "",
            :telephone => user_params[:telephone] || "",
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

                default_role_id = current_user.account.settings.find_by(:name => "default_role_id")&.value
                owner_role_id =  current_user.account.roles.find_by(:name => "owner").id
                if default_role_id.present? && default_role_id != owner_role_id
                    # assign default role
                    user.user_roles.create({ role:  current_user.account.roles.find_by(:id => default_role_id)})

                else
                    # assign limited role
                    user.user_roles.create({ role: current_user.account.roles.find_by(:name => "limited") })
                end 
                
            end

            # saving logs with information about the creation of the user
            user.logs.create({ title: "user_created_at", description: Date2.new.date_time.to_s })
            user.logs.create({ title: "user_created_by", description: current_user.email })
            user.logs.create({ title: "user_created_with_role", description: user.user_roles.first.role.name + " " + user.user_roles.first.role.id.to_s})

            User.log_activity_create(current_user, user)

            self.resource = user

            begin
                # users created through the administration area does not need to confirm their accounts
                # instead we send a password reset link, so they can have access to the platform
                UserMailer.with(user: user).invitation_instructions.deliver_now
            rescue => exception
                Honeybadger.notify(exception)
                user.logs.create({ title: "user_creation_email_failed ", description: exception.message })
            end

        else
            self.error(user.errors.full_messages.to_sentence)
        end

        self

    end

    def update params

        old_attributes = resource.detail.attributes.merge({
            active: resource.active
        })

        if resource.update(params)
            new_attributes = resource.detail.attributes.merge({
                active: resource.active
            })

            ::User.log_activity_update(current_user, resource, old_attributes, new_attributes)
        else
            self.error(resource.errors.full_messages.to_sentence)
        end

        self
    end

    def find id
        self.resource = current_user.account.users.joins(:detail).find_by(id: id)
        self
    end
end
