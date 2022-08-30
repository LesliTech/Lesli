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


require "lesli_request_helper"


RSpec.describe "PUT:/administration/account/settings/:id.json", type: :request do
    include_context "request user authentication"

    # test cases
    it "is expected to update a datetime time zone setting record" do

        actual_settings = @current_user.account.settings

        for setting in actual_settings
            if setting.name == "datetime_time_zone"
                id = setting.id
            end
        end

        new_data = { 
            :name => "datetime_time_zone",
            :value => Faker::Address.time_zone
        }

        put("/administration/account/settings/#{id}.json", params: {
            settings: new_data
        })

        # shared examples
        expect_response_with_successful

    end

    it "is expected to update the primary theme color in settings records" do

        actual_settings = @current_user.account.settings

        for setting in actual_settings
            if setting.name == "lesli_theme_color_primary"
                id = setting.id
            end
        end

        new_data = { 
            :name => "lesli_theme_color_primary",
            :value => Faker::Color.hex_color()
        }

        put("/administration/account/settings/#{id}.json", params: {
            settings: new_data
        })

        # shared examples
        expect_response_with_successful

    end

    
end

