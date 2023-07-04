=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

include ActionView::Helpers::NumberHelper

module LC
    class Currency
        # default configuration
        @settings = {
            precision: 2,
            symbol: "$",
            separator: ".",
            delimiter: ",",
            format: "%u %n"
        }

        if Rails.application.config.lesli.dig(:configuration, :currency)
            @settings = @settings.merge(
                Rails.application.config.lesli.dig(:configuration, :currency)
            )
        end

        def self.format(value, symbol = symbol(), precision = @settings[:precision])
            return "#{number_to_currency(value, separator: @settings[:separator], delimiter: @settings[:delimiter], precision: precision, unit: symbol, format: @settings[:format])}"
        end

        def self.symbol
            return @settings[:symbol]
        end
    end
end
