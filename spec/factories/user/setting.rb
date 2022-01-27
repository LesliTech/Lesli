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

FactoryBot.define do
    factory :user_setting, class: "User::Setting" do
        name { Faker::Lorem.word }
        value { Faker::Lorem.word }
    end

    factory :invalid_user_setting, class: "User::Setting" do
        name { "" }
        value { "" }
    end

    factory :user_setting_nil_params, class: "User::Setting" do
        name { }
        value { }
    end
end