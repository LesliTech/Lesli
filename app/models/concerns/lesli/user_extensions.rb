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
    module UserExtensions
        extend ActiveSupport::Concern

        # Set the user alias based on the full_name.
        def set_alias
            if self.alias.blank?
                self.alias = full_name_initials() 
                self.save
            end
        end

        # Returns the user's full name if available, or their email as a fallback.
        def full_name
            if first_name.present?
                [first_name, last_name.presence].compact.join(" ")
            else
                email
            end
        end

        # Retrieves and returns the name initials of the user 
        # depending on the available information.
        def full_name_initials
            return "" if first_name.blank?

            initials = first_name.strip[0]&.upcase || ""
            initials += last_name.strip[0]&.upcase if last_name.present?
            initials
        end

        # Returns the local configuration for the user,
        # if there is no locale the default local of the platform will be returned
        def locale
            user_locale = self.settings.find_by(name: "locale")

            # return the desire locale by the user
            return user_locale.value.to_sym if user_locale

            # create a desire locale if the record does not exist 
            self.settings.create_with(:value => I18n.locale).find_or_create_by(:name => "locale")

            # reevaluate
            self.locale()
        end

        # Return a string with the names of all the roles assigned to the user
        def role_names 
            self.lesliroles.pluck(:name).join(', ')
        end



        
        # Returns MFA settings configured by the user
        def mfa_settings
            mfa_enabled = self.settings.create_with(:value => false).find_or_create_by(:name => "mfa_enabled")
            mfa_method = self.settings.create_with(:value => :email).find_or_create_by(:name => "mfa_method")
            {
                :enabled => mfa_enabled.nil? ? false : mfa_enabled.value == 't',
                :method => mfa_method.nil? ? nil : mfa_method.value.to_sym
            }
        end

        # @return [void]
        # @description Register a new notification for the current user
        # @param subject String Short notification description
        # @param body String Long notification description
        # @param url String Link to notified object
        # @param category String Kind of notification: info, warning, danger, success.
        def notification subject, body:nil, url:nil, category:"info"
            Courier::Bell::Notification.new(self, subject, body:body, url:url, category:category)
        end

        # @return [void]
        # @description Register a new notification for the current user
        # @param subject String Short notification description
        # @param body String Long notification description
        # @param url String Link to notified object
        # @param category String Kind of notification: info, warning, danger, success.
        def notifications quantity=5, category:"info"
            query = {
                :pagination => {
                    :perPage => quantity,
                    :page => 1
                }
            }
            Lesli::Courier.new(:lesli_bell, []).from(:notification_service, self, query).call(:index)
        end

        # @return [CloudDriver::Calendar]
        # @description Return the default calendar of the user if source_code is not provided.
        # If source_code is provided the method return the specified source calendar.
        def calendar source_code: :lesli
            return Courier::Driver::Calendar.get_user_calendar(self, source_code: source_code, default: true) if source_code == :lesli
            Courier::Driver::Calendar.get_user_calendar(self, source_code: source_code)
        end
    end
end
