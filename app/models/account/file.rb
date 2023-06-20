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

class Account::File < CloudObject::File
    belongs_to :account
    belongs_to :cloud_object, class_name: "::Account", foreign_key: "account_id"

    enum category: {
        app_icon: "app_icon",
        app_logo: "app_logo",
        favicon: "favicon"
    }

    def self.index(current_user, query)
        data = current_user.account.files

        # if query[:filters]["only"] == "logos"
        #     data = data.where("file_type in (?)", self.file_types.keys)
        # end

        data
    end

    def destroy
        update(attachment: nil, attachment_s3: nil)

        super
    end

    protected

    # @return [Boolean] True if the objects on this class should be publicly accessible. False otherwise.
    # @descriptions This method returns whether all the objects on this model are publicly accessible. By default, they are not
    # @example
    #     CloudHelp::Ticket::File.public_accesibility # This will return false, unless this method is overriden on that specific model
    def self.public_accesibility
        return true
    end
end
