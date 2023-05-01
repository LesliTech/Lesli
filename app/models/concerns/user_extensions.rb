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
module UserExtensions
    extend ActiveSupport::Concern


    # @return [void]
    # @description Register a new notification for the current user
    # @param subject String Short notification description
    # @param body String Long notification description
    # @param url String Link to notified object
    # @param category String Kind of notification: info, warning, danger, success.
    def notification subject, body:nil, url:nil, category:"info"
        Courier::Bell::Notification.new(self, subject, body:body, url:url, category:category)
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


    # @return [String]
    # @description Returns the local configuration for the user if there is no locale the default local
    # of the platform will be returned
    # @example
    #      locale = User.last.locle
    #      will print something like: :es
    def locale
        user_locale = settings.find_by(name: "locale")

        if user_locale
            return user_locale.value.to_sym
        end

        # return current locale
        I18n.locale 
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
