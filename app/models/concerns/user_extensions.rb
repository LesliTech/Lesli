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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

# User extension methods
# Custom methods that belongs to a instance user
module UserExtensions
    extend ActiveSupport::Concern


    # @return [nil]
    # @description Set the user alias based on the full_name.
    # @example
    #     puts current_user.full_name # John Doe
    #     puts current_user.set_alias # John D.
    def set_alias
        if self.alias.blank?
            self.alias = full_name_initials() 
            self.save
        end
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


    # @return [String] The name of this user.
    # @description Retrieves and returns the name of the user depending on the available information.
    #     The name can be a full name (first and last names), just the first name, or, in case the information
    #     is not available, the email. This method currently is available if the the CloudLock engine exists,
    #     otherwise, it returns *nil*
    # @example
    #     my_user = current_user
    #     puts my_user.name # can print John Doe
    #     other_user = User.last
    #     puts other_user.name # can print jane.smith@email.com
    def full_name
        self.first_name.blank? ? email : self.first_name + " " + self.last_name.to_s
    end


    # @return [String] The name initials of this user.
    # @description Retrieves and returns the name initials of the user depending on the available information.
    # @example
    #     puts current_user.full_name_initials # would print JD
    def full_name_initials
        self.first_name.blank? ? "" : self.first_name[0].upcase + "" + (self.last_name.blank? ? "" : self.last_name[0].upcase)
    end


    # @return [String]
    # @description Returns the local configuration for the user if there is no locale the default local
    # of the platform will be returned
    # @example
    #      locale = User.last.locle
    #      will print something like: :es
    def locale
        user_locale = self.settings.find_by(name: "locale")

        # return the desire locale by the user
        return user_locale.value.to_sym if user_locale

        # create a desire locale if the record does not exist 
        self.settings.create_with(:value => I18n.locale).find_or_create_by(:name => "locale")

        # reevaluate
        self.locale()
    end


    def role_names 
        user_roles = self.lesliroles.map(&:name).join(", ")
    end


    # @return [void]
    # @description Returns MFA settings configured by the user
    # Example
    #   user_mfa_settings = User.find(2).mfa_settings
    #   puts user_mfa_settings
    #       { :mfa_enabled => true, :mfa_method => "email"}
    def mfa_settings
        mfa_enabled = self.settings.create_with(:value => false).find_or_create_by(:name => "mfa_enabled")
        mfa_method = self.settings.create_with(:value => :email).find_or_create_by(:name => "mfa_method")
        {
            :enabled => mfa_enabled.nil? ? false : mfa_enabled.value == 't',
            :method => mfa_method.nil? ? nil : mfa_method.value.to_sym
        }
    end
end
