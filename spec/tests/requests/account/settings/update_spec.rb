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

    def create_settings (settings)
        settings.each do |key, value|
            setting = @current_user.account.settings.find_by(name: key)
            if setting.present?
                setting.update_attribute(:value, value)
            else
                @current_user.account.settings.create!(name: key, value: value)
            end
        end
    end

    # test cases
    it "is expected to update a datetime time zone setting record" do

        new_settings = create_settings({
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
        })

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

        new_settings = create_settings({
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
        })

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

