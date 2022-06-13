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


# include helpers, configuration & initializers for request tests
require "rails_helper"


RSpec.describe LC::Currency, type: :model do

    it "LC::Currency.symbol with default values" do
        default_settings = Rails.application.config.lesli[:configuration]
        default_settings = default_settings[:currency] if default_settings
        symbol = "$"

        if default_settings
            symbol = default_settings[:symbol] if default_settings[:symbol]
        end

        result = LC::Currency.symbol
        expect(result).to eq(symbol)
    end

    it "LC::Currency.format with default values" do
        default_settings = Rails.application.config.lesli[:configuration]
        default_settings = default_settings[:currency] if default_settings

        symbol = "$"
        separator = "."
        delimiter = ","
        format_ = "%u %n"
        precision = 2

        if default_settings
            symbol = default_settings[:symbol] if default_settings[:symbol]
            separator = default_settings[:separator] if default_settings[:separator]
            delimiter = default_settings[:delimiter] if default_settings[:delimiter]
            format_ = default_settings[:format] if default_settings[:format]
            precision = default_settings[:precision].to_i if default_settings[:precision]
        end

        number = Faker::Number.decimal(l_digits: 3, r_digits: 8)
        result = LC::Currency.format(number)
        expected = number_to_currency(
            number,
            separator: separator,
            delimiter: delimiter,
            precision: precision,
            unit: symbol,
            format: format_
        )

        expect(result).to eq (expected)
    end

    it "LC::Currency.format with custom values" do
        default_settings = Rails.application.config.lesli[:configuration]
        default_settings = default_settings[:currency] if default_settings
        
        separator = "."
        delimiter = ","
        format_ = "%u %n"

        if default_settings
            separator = default_settings[:separator] if default_settings[:separator]
            delimiter = default_settings[:delimiter] if default_settings[:delimiter]
            format_ = default_settings[:format] if default_settings[:format]
        end

        custom_symbol = Faker::Currency.symbol
        custom_precision = Faker::Number.within(range: 1..3)
        number = Faker::Number.decimal(l_digits: 3, r_digits: 8)

        result = LC::Currency.format(number, custom_symbol, custom_precision)
        expected = number_to_currency(
            number,
            separator: separator,
            delimiter: delimiter,
            precision: custom_precision,
            unit: custom_symbol,
            format: format_
        )

        expect(result).to eq (expected.to_s)
    end
end
