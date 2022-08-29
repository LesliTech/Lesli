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


RSpec.describe "GET:/administration/account/settings.json", type: :request do
    include_context "request user authentication"

    # test cases
    it "is expected to respond with all the records from account settings" do
        settings = []
        get("/administration/account/settings.json")


        # shared examples
        expect_response_with_successful

        expect(response_body).to be_a(Array)

        #Get the settings from the response body
        for i in response_body do
            settings.append(i['name'])
        end

        # Verify if the expected settings are present in the response body
        expect("datetime_format_date").to be_in(settings)
        expect("datetime_format_time").to be_in(settings)
        expect("datetime_format_date_words").to be_in(settings)
        expect("datetime_format_date_time").to be_in(settings)
        expect("datetime_format_date_time_words").to be_in(settings)
        expect("datetime_time_zone").to be_in(settings)
        expect("password_enforce_complexity").to be_in(settings)
        expect("password_minimum_length").to be_in(settings)
        expect("password_expiration_time_days").to be_in(settings)
        expect("password_special_char_count").to be_in(settings)
        expect("password_uppercase_count").to be_in(settings)
        expect("password_lowercase_count").to be_in(settings)
        expect("password_digit_count").to be_in(settings)
        
    end

end
