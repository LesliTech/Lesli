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

module Docm
    module Parser
        class Xlsx
            def self.parse records

                # IMPORTANT: Dynamic columns are not allowed
                # example for :
                #[
                #  {name: 'Luis', age: 25, country: 'Guatemala'},
                #  {name: 'Alberto', country: 'Germany'}
                #]
                # the excel is going to generate:
                # name    |  age        | Country
                # - - - - | - - - - - - | - - - - - -
                # Luis    |  25         | Guatemala
                # Alberto |  Germany    |
                # you have to always send the exactly number of columns (does not matter if you send columns with empty data)
                # then the proccess can parse the excel data properly

                # Create a excel object with headers and rows,
                # every row is an array of columns
                excel = {
                  'headers' => [],
                  'rows' => []
                }

                records.each do |record|

                  current_row = []

                  record.each do |key, value|

                    excel['headers'].push(key) unless excel['headers'].include?(key)

                    current_row.push(value)

                  end

                  excel['rows'].push(current_row)

                end

                return excel

            end
        end
    end
end
