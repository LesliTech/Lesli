=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# User extension methods
# Custom methods that belongs to a instance user
module Lesli
    module UserSecurity
        extend ActiveSupport::Concern

        def max_level_permission

            # get the max level permission from roles assigned to the user
            self.lesliroles.maximum(:permission_level) || 0
        end

        # check if user has roles with specific names
        def has_roles? *roles
            !roles.intersection(self.roles.map{ |r| r[:name] }).empty?
        end

        # check the privilege cache to check if user is able 
        # to perform a specific action in a specific controller
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

        # Check if user has enough privilege to work with the given role
        def can_work_with_role?(role_id)

            # get the role if only id is given
            role = self.account.roles.find_by(:id => role_id)

            # false if role not found
            return false if role.blank?

            # not valid role without object levelpermission defined
            return false if role.level_permission.blank?

            # get the max level permission from the roles the user has assigned
            user_role_max_level_permission = self.roles.map(&:level_permission).max()

            # check if user can work with the level permission of the role is trying to modify
            # Note: user only can assigned an level permission below the max of his own roles
            # Current user cannot assign role if role to assign is the same of the greater role 
            # assigned to the current user
            user_role_max_level_permission >= role.level_permission
        end

        # Checks configuration of all the roles assigned to the user
        # if user has a role with "default path" to use as home to redirect after login
        # IMPORTANT: This home path is used only the send the user after login, the user
        #            and the role are not limited by this configuration
        def has_role_with_default_path?()

            # get the roles that contains a path
            role = self.roles.where.not(path_default: [nil, ""])

            # here we must order the results descendant because we must
            # keep the path of the hightest level permission role.
            # Example: we should use the path of the admin role if user has
            # admin & employee roles, also order by default_path, so we get first 
            # the roles with path in case the user has roles with the same level permission
            role = role.order(level_permission: :desc).order(:path_default)

            # get the first role found, due previously we sort in a descendant order
            # the first role is going to be the one with highest level permission
            # this is going to return nil if no role was found
            default_path = role.first&.path_default  || "/"

            # if first loggin for account owner send him to the onboarding page
            if self.account.onboarding? && self.has_roles?("owner")
                default_path = "/onboarding"
            end

            default_path
        end

        # Checks configuration of all the roles assigned to the user
        # if user has a role limited to a defined path
        # if user has a high privilege role that overrides any other role configuration
        def has_role_limited_to_path?()

            # get the roles ordering in descendant mode because we must
            # keep the path of the hightest level permission role.
            # Example: we should use the path of the admin role if user has
            # admin & employee roles, also order by default_path, so we get first 
            # the roles with path in case the user has roles with the same level permission
            role = self.roles.order(level_permission: :desc).order(:path_default)

            # get the first role found, due previously we sort in a descendant order
            # the first role is going to be the one with highest level permission
            # this is going to return nil if no role was found
            role = role.first

            # return the path of the role if is limited to a that specific path
            return role.path_default if role.path_limited == true 

            # return nil if role has no limits
            return nil
        end

        # Sets this user as inactive and removes complete access to the platform
        def revoke_access
            self.update(active: false)
        end

        # Change user password forcing user to reset the password
        def set_password_as_expired
            self.update(password_expiration_at: Time.current)
        end

        # @description Change user password forcing user to reset the password
        def set_password_for_reset
            generate_password_reset_token()
        end

        def has_expired_password?
            return false if self.password_expiration_at.blank?
            return Time.current > self.password_expiration_at
        end

        # Check if user has a confirmed telephone number
        def has_telephone_confirmed?
            !!self.telephone_confirmed_at
        end

        # Change user password forcing user to reset the password
        def generate_password_reset_token
            raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

            self.password = raw
            self.reset_password_token   = enc
            self.reset_password_sent_at = Time.now.utc
            save(validate: false)
            raw
        end

        # Generate a token to validate telephone number
        def generate_telephone_token(length=4)
            raw, enc = Devise.token_generator.create(
                self.class, 
                :telephone_confirmation_token, 
                type:'number', 
                length:length
            )

            self.telephone_confirmation_token   = enc
            self.telephone_confirmation_sent_at = Time.now.utc
            self.telephone_confirmed_at = nil
            save(validate: false)
            raw
        end

        # Mark telephone number as valid and confirmed
        def confirm_telephone_number
            self.telephone_confirmation_token   = nil
            self.telephone_confirmation_sent_at = nil
            self.telephone_confirmed_at = Time.now.utc
            save(validate: false)
        end

        # Return a hash that contains all the abilities grouped by 
        # controller and define every action privilege. It also
        # evaluate if the user has the ability no matter if is given 
        # to the user by role or by itself.
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
    end
end
