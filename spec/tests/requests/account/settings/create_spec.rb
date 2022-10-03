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

RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/account/settings.json", type: :request do
        include_context "request user authentication"
        
        settings_params = {
            datetime_format_date: "%d/%m/%Y",
            datetime_format_time: "%H:%M:%S",
            datetime_format_date_words: "%B %d, %Y",
            datetime_format_date_time: "%d/%m/%Y %H:%M:%S",
            datetime_format_date_time_words: "%B %d, %Y %H:%M:%S",
            datetime_time_zone: Faker::Address.time_zone,
            password_enforce_complexity: Faker::Number.between(from: 0, to: 1),
            password_minimum_length: Faker::Number.between(from: 1, to: 20),
            password_expiration_time_days: Faker::Number.between(from: 1, to: 365),
            password_special_char_count: Faker::Number.between(from: 1, to: 10),
            password_uppercase_count: Faker::Number.between(from: 1, to: 10),
            password_lowercase_count: Faker::Number.between(from: 1, to: 10),
            password_digit_count: Faker::Number.between(from: 1, to: 10),
            lesli_theme_color_primary: Faker::Color.hex_color(),
            lesli_theme_color_secondary: Faker::Color.hex_color(),
            lesli_theme_header_color: Faker::Color.hex_color(),
            lesli_theme_sidebar_color: Faker::Color.hex_color(),
            lesli_theme_color_background: Faker::Color.hex_color(),
            lesli_theme_font_color: Faker::Color.hex_color(),
            lesli_theme_font_size: Faker::Number.between(from: 1, to: 20)
        }

        it "is expected to respond with error when params is empty" do
            post("/administration/account/settings.json", params: {
            })

            #share examples
            expect_response_with_error
        end 

        
        it "is expected to respond with error when settings in params is empty" do
            post("/administration/account/settings.json", params: {
                settings: {}
            })

            #share examples
            expect_response_with_error
        end 

        it "is expected to respond with succesful with settings value nil" do
            post("/administration/account/settings.json", params: {
                settings: {:theme => nil}
            })

            #share examples
            expect_response_with_successful

            #verify if the setting sent was correctly save
            expect(@current_user.account.settings.find_by(name: "theme")["value"]).to be_nil
        end 

        it "is expected to respond with succesful set/create settings" do

            post("/administration/account/settings.json", params: {
                settings: settings_params
            })

            #share examples
            expect_response_with_successful

            #verify if the setting sent was correctly save

            expect(response_body['datetime_format_date']).to eql(settings_params['datetime_format_date'])
    
            expect(response_body['datetime_format_time']).to eql(settings_params['datetime_format_time'])
    
            expect(response_body['datetime_format_date_words']).to eql(settings_params['datetime_format_date_words'])
    
            expect(response_body['datetime_format_date_time']).to eql(settings_params['datetime_format_date_time'])
    
            expect(response_body['datetime_format_date_time_words']).to eql(settings_params['datetime_format_date_time_words'])
    
            expect(response_body['datetime_time_zone']).to eql(settings_params['datetime_time_zone'])
    
            expect(response_body['password_enforce_complexity']).to eql(settings_params['password_enforce_complexity'])
    
            expect(response_body['password_minimum_length']).to eql(settings_params['password_minimum_length'])
    
            expect(response_body['password_expiration_time_days']).to eql(settings_params['password_expiration_time_days'])
    
            expect(response_body['password_special_char_count']).to eql(settings_params['password_special_char_count'])
    
            expect(response_body['password_uppercase_count']).to eql(settings_params['password_uppercase_count'])
    
            expect(response_body['password_lowercase_count']).to eql(settings_params['password_lowercase_count'])
    
            expect(response_body['password_digit_count']).to eql(settings_params['password_digit_count'])
    
            expect(response_body['lesli_theme_color_primary']).to eql(settings_params['lesli_theme_color_primary'])
    
            expect(response_body['lesli_theme_color_secondary']).to eql(settings_params['lesli_theme_color_secondary'])
    
            expect(response_body['lesli_theme_header_color']).to eql(settings_params['lesli_theme_header_color'])
    
            expect(response_body['lesli_theme_sidebar_color']).to eql(settings_params['lesli_theme_sidebar_color'])
    
            expect(response_body['lesli_theme_color_background']).to eql(settings_params['lesli_theme_color_background'])
    
            expect(response_body['lesli_theme_font_color']).to eql(settings_params['lesli_theme_font_color'])
    
            expect(response_body['lesli_theme_font_size']).to eql(settings_params['lesli_theme_font_size'])
        end
    end
end
