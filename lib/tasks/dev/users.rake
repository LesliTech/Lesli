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

namespace :dev do
    namespace :users do

        desc "Load users for development environment"
        task :load => :environment do |task, args|

            # development user
            user = Rails.application.config.lesli[:account]

            create_development_user(["owner", "mr", user[:name], "", user[:email]])

            # core development users
            [
                ["owner",   "mr", "Owner",   "user", "owner@lesli.cloud"],
                ["sysadmin","mr", "SysAdmin","user", "admin@lesli.cloud"],
                ["limited", "mr", "Limited", "user", "limited@lesli.cloud"],
                ["guest",   "mr", "Guest",   "user", "guest@lesli.cloud"],
                ["sysadmin","mr", "Test",    "user", "test@lesli.cloud"],
                ["api",     "mr", "API",     "user", "api@lesli.cloud"],
            ].each do |user|

                user = create_development_user(user)
                STDOUT.puts("User with email: #{user['email']} registered.")

            end


            # notify
            LC::Debug.msgc "Users successfully created!"

        end
    end
end


def create_development_user dev_user, password=nil

    # get password
    if password.blank?
        password = Rails.application.config.lesli[:security][:password]
        password = password + Time.now.year.to_s + "$"
    end

    # user information
    email = dev_user[4]
    last_name = dev_user[3]
    role_name = dev_user[0]
    salutation = dev_user[1]
    first_name = dev_user[2]

    account = Account.find_by(company_name: Rails.application.config.lesli[:account][:name])

    # create development users if email is not registered yet
    ::User.find_or_create_by(email: email) do |user|
        user.password = password
        user.password_confirmation = password
        user.account = account
        user.confirm if not user.confirmed?

        user.detail.salutation = salutation
        user.detail.first_name = first_name
        user.detail.last_name = last_name

        user.user_roles.create({ role: Role.find_by("name" => role_name) })

        user.save!

        user.account.user = user
        user.account.save!

        if user
            user.settings.create(:name => 'locale', :value => Rails.application.config.lesli[:env][:default_locale]) # add locale
        end
    end
end
