=begin

Copyright (c) 2020, all rights reserved.

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

# get settings
company = Rails.application.config.lesli_settings["account"]["company"]

# create account
model = Account.find_or_create_by(company_name: company["name"]) do |account|
    account.company_tag_line = company["tag_line"]
    account.status = 1
end

p "Account successfully created!"
