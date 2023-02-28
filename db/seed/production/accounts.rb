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


# get settings
company = Rails.application.config.lesli.dig(:account)


# create account
Account.find_or_create_by(company_name: company[:name]) do |account|
    account.company_name = company[:name]
    account.public_email = company[:email]
    account.company_tag_line = company[:tag_line]
    account.registered!
    account.save!
end


L2.info "Account successfully created!"
