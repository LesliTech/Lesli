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

FactoryBot.define do
    factory :webpush, class: "User::Webpush" do
        endpoint { Faker::Internet.url }
        auth_key { Faker::Lorem.word }
        p256dh_key { Faker::Lorem.word }
        users_id { nil } # this param will be given by the call of create_list in the test
    end
end