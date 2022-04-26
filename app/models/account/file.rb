=begin

Copyright (c) 2021, all rights reserved.

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

class Account::File < CloudObject::File

    enum file_type: {
        app_icon: "app_icon",
        app_logo: "app_logo",
        favicon: "favicon",
        template: "template",
        template_audience: "template_audience"
    }

    belongs_to :account, foreign_key: "accounts_id"
    belongs_to :cloud_object, class_name: "::Account", foreign_key: "accounts_id"

    def self.index(current_user, query)
        data = current_user.account.files

        if query[:filters]["only"] == "logos"
            data = data.where("file_type in (?)", self.file_types.keys)
        end

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
