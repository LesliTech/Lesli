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


def create_development_user dev_user, password=nil

    # get password
    if not password
        password = Rails.application.config.lesli_settings["configuration"]["security"]["password"]["development"]
        password = password + Time.now.year.to_s + "$"
    end

    # user information
    email = dev_user[4]
    last_name = dev_user[3]
    role_name = dev_user[0]
    salutation = dev_user[1]
    first_name = dev_user[2]

    # create development users if email is not registered yet
    ::User.find_or_create_by(email: email) do |user|
        user.password = password
        user.password_confirmation = password
        user.account = Account.first
        user.confirm if not user.confirmed?
        
        user.detail.salutation = salutation
        user.detail.first_name = first_name
        user.detail.last_name = last_name

        user.user_roles.create({ role: Role.find_by("name" => role_name) })
        
        user.save!

        user.account.user = user
        user.account.save!
    end

end

