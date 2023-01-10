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


# User extension methods
# Custom methods that belongs to a instance user
module UserGuard
    extend ActiveSupport::Concern

    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    # @param *roles [String] One or more roles to be checked
    # check role of the user
    def has_roles? *roles
        !roles.intersection(self.roles.map{ |r| r[:name] }).empty?
    end


    # @return [Boolean]
    # @description Return true/false if a user has all the privileges to do an action based on a controllers list,
    #     this validation includes the privileges that the user could have based on its roles and the privileges
    #     that has been added to the specific user.
    # @examples
    #     validate privileges on a controller with the same actions on each one
    #     controllers = ["cloud_house/companies", "cloud_house/projects"]
    #     actions = ["index", "update"]
    #
    #     current_user.has_privileges4?(controllers, actions)
    def has_privileges4?(controller, action, form='html')

        # set html by default, even if nil is sent as parameter for "form"
        form ||= 'html'

        begin
            !self.privileges
            .where("role_privileges.controller = ?", controller)
            .where("role_privileges.action = ?", action)
            .where("role_privileges.form = ?", form)
            .first.blank?
        rescue => exception
            Honeybadger.notify(exception)
            return false
        end
    end


    # @return [Hash]
    # @description Return a hash that contains all the abilities grouped by controller and define every action privilege. It also
    #     evaluate if the user has the ability no matter if is given to the user by role or by itself.
    # @examples
    #     current_user.abilities_by_controller
    def abilities_by_controller

        # Due this method is executed on every HTML request, we use low level cache to improve performance
        # It is not usual to the privileges to change so often, however the cache will be deleted
        # after every commit on roles, role descriptors and privileges
        #Rails.cache.fetch(user_cache_key(abilities_by_controller, self), expires_in: 12.hours) do

            # Abilities hash where we will save all the privileges the user has to
            abilities = {}

            # We check all the privileges the user has in the cache table according to his roles
            # and create a key per controller (with the full controller name) that contains an array of all the 
            # methods/actions with permission
            self.privileges.all.each do |privilege|
                abilities[privilege.controller] = [] if abilities[privilege.controller].nil?
                abilities[privilege.controller] << privilege.action
            end

            abilities

        #end
    end


    # @return Boolean
    # @description Check if user has enough privilege to work with the given role
    def can_work_with_role?(role)

        # get the role if only id is given
        role = self.account.roles.find_by(:id => role) unless role.class.name == "Role"

        # false if role not found
        return false if role.blank?

        # not valid role without object levelpermission defined
        return false if role.object_level_permission.blank?

        # owner role can work with all the roles
        return true if !self.roles.find_by(name: 'owner').blank?

        # get the max object level permission from the roles the user has assigned
        user_role_level_max = self.roles.map(&:object_level_permission).max()

        # check if user can work with the object level permission of the role is trying to modify
        # Note: user only can assigned an object level permission below the max of his own roles
        # Current user cannot assign role if
        #       role to assign has greater object level permission than the greater role assigned to the current user
        #       role to assign is the same of the greater role assigned to the current user
        #       current user is not sysadmin or owner
        return false if role.object_level_permission >= user_role_level_max

        # user can work with this role :)
        return true

    end


    # @return [nil,string]
    # @description Checks configuration of all the roles assigned to the user
    # if user has a role with "default path" to use as home to redirect after login
    # IMPORTANT: This home path is used only the send the user after login, the user
    #            and the role are not limited by this configuration
    def has_role_with_default_path?()

        # get the roles that contains a path
        role = self.roles.where.not(default_path: [nil, ""])

        # here we must order the results descendant because we must
        # keep the path of the hightest object level permission role.
        # Example: we should use the path of the admin role if user has
        # admin & employee roles, also order by default_path, so we get first 
        # the roles with path in case the user has roles with the same object level permission
        role = role.order(object_level_permission: :desc).order(:default_path)

        # get the first role found, due previously we sort in a descendant order
        # the first role is going to be the one with highest object level permission
        # this is going to return nil if no role was found
        role.first&.default_path

    end


    # @return [nil,string]
    # @description Checks configuration of all the roles assigned to the user
    # if user has a role limited to a defined path
    # if user has a high privilege role that overrides any other role configuration
    def has_role_limited_to_path?()

        # get the roles ordering in descendant mode because we must
        # keep the path of the hightest object level permission role.
        # Example: we should use the path of the admin role if user has
        # admin & employee roles, also order by default_path, so we get first 
        # the roles with path in case the user has roles with the same object level permission
        role = self.roles.order(object_level_permission: :desc).order(:default_path)

        # get the first role found, due previously we sort in a descendant order
        # the first role is going to be the one with highest object level permission
        # this is going to return nil if no role was found
        role = role.first

        # return the path of the role if is limited to a that specific path
        return role.default_path if role.limit_to_path == true 

        # return nil if role has no limits
        return nil
    end


    # @return [void]
    # @description Sets this user as inactive and removes complete access to the platform from them
    # @example
    #     old_user = User.last
    #     old_user.revoke_access
    def revoke_access
        self.update(active: false)
    end


    # @return [void]
    # @description Change user password forcing user to reset the password
    def set_password_as_expired
        self.update(password_expiration_at: Time.current)
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def has_expired_password?
        return false if self.password_expiration_at.blank?
        return Time.current > self.password_expiration_at
    end


    # @return String
    # @description Change user password forcing user to reset the password
    def generate_password_reset_token
        raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

        self.reset_password_token   = enc
        self.reset_password_sent_at = Time.now.utc
        save(validate: false)
        raw
    end


    # @return [Boolean]
    # @description check if user has a confirmed telephone number
    def telephone_confirmed?
        !!self.telephone_confirmed_at
    end


    # @return String
    # @description Generate a token to validate telephone number
    def generate_telephone_token(length=4)

        raw, enc = Devise.token_generator.create(self.class, :telephone_confirmation_token, type:'number', length:length)

        self.telephone_confirmation_token   = enc
        self.telephone_confirmation_sent_at = Time.now.utc
        self.telephone_confirmed_at = nil
        save(validate: false)
        raw
    end


    # @return String
    # @description Mark telephone number as valid and confirmed
    def confirm_telephone_number
        self.telephone_confirmation_token   = nil
        self.telephone_confirmation_sent_at = nil
        self.telephone_confirmed_at = Time.now.utc
        save(validate: false)
    end
end
