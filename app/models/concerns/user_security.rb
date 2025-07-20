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


# User extension methods
# Custom methods that belongs to a instance user
module UserSecurity
    extend ActiveSupport::Concern


    def max_object_level_permission

        # get the max object level permission from roles assigned to the user
        level = self.lesliroles.maximum(:permission_level)

        # if user has no roles assigned, we return the lowest role available 
        # NOTE: This should not be possible due the user needs a role to login
        unless level 
            return (self.account.roles.minimum(:permission_level))
        end

        # return the level found
        level
    end

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
    #     current_user.has_privileges?(controllers, actions)
    def has_privileges_for?(controller, action)
        begin
            return self.privileges.where(
                controller: controller,
                action: action,
                active: true
            ).exists?
        rescue => exception
            return false
        end
    end


    # @return [Hash]
    # @description Return a hash that contains all the abilities grouped by controller and define every action privilege. It also
    #     evaluate if the user has the ability no matter if is given to the user by role or by itself.
    # @examples
    #     current_user.abilities_by_controller
    def abilities_by_controller

        # Abilities hash where we will save all the privileges the user has to
        abilities = {}

        # We check all the privileges the user has in the cache table according to his roles
        # and create a key per controller (with the full controller name) that contains an array of all the 
        # methods/actions with permission
        # self.privileges.all.each do |privilege|
        #     abilities[privilege.controller] = [] if abilities[privilege.controller].nil?
        #     abilities[privilege.controller] << privilege.action
        # end

        abilities

    end


    # @return Boolean
    # @description Check if user has enough privilege to work with the given role
    def can_work_with_role?(role)

        # get the role if only id is given
        role = self.account.roles.find_by(:id => role) unless role.class.name == "Lesli::Role"

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
        role = self.roles.where.not(path_default: [nil, ""])

        # here we must order the results descendant because we must
        # keep the path of the hightest object level permission role.
        # Example: we should use the path of the admin role if user has
        # admin & employee roles, also order by default_path, so we get first 
        # the roles with path in case the user has roles with the same object level permission
        role = role.order(object_level_permission: :desc).order(:path_default)

        # get the first role found, due previously we sort in a descendant order
        # the first role is going to be the one with highest object level permission
        # this is going to return nil if no role was found
        default_path = role.first&.path_default  || "/"

        # if first loggin for account owner send him to the onboarding page
        if self.account.onboarding? && self.has_roles?("owner")
            default_path = "/onboarding"
        end

        default_path

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
        role = self.lesliroles.order(object_level_permission: :desc).order(:path_default)

        # get the first role found, due previously we sort in a descendant order
        # the first role is going to be the one with highest object level permission
        # this is going to return nil if no role was found
        role = role.first

        # return the path of the role if is limited to a that specific path
        return role.path_default if role.path_limited == true 

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
    # @description Change user password forcing user to reset the password
    # @todo validate object level permission
    def password_reset
        pass = SecureRandom.hex(10)
        self.update(password: pass)
        pass
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
