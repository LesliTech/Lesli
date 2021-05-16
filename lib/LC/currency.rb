=begin

Copyright (c) 2021, all rights reserved.

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

include ActionView::Helpers::NumberHelper

module LC
    class Currency
        # default configuration
        @settings = {
            "precision" => 2,
            "symbol" => "USD",
            "separator" => ".",
            "delimiter" => ","
        }

        @settings = @settings.merge(
            Rails.application.config.lesli_settings["configuration"]["currency"]
        )

        def self.format(value, symbol = symbol(), precision=@settings["precision"])
            return "#{number_to_currency(value, separator: @settings["separator"], delimiter: @settings["delimiter"], precision: precision, unit: symbol)}"
        end

        def self.symbol
            return @settings["symbol"]
        end
    end
end
