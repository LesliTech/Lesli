=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
            
                    excel['headers'].push(key) if not excel['headers'].include?(key)
            
                    current_row.push(value)
            
                  end
            
                  excel['rows'].push(current_row)
            
                end
            
                return excel
            
            end
        end
    end
end
