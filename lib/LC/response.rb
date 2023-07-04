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

module LC

    class Response
        
        # Ussage example
        # tasks = Task
        # .joins(:detail)
        # .page(query[:pagination][:page])
        # .per(query[:pagination][:perPage])
        # 
        # response_message = LC::Response.pagination(
        #     tasks.current_page,
        #     tasks.total_pages,
        #     tasks.total_count,
        #     tasks.length,
        #     tasks
        # )
        # respond_with_successful(response_message)
        # DEPRECATED: Use LesliServices instead
        def self.pagination current_page, total_pages, total_count, length, data
            {
                pagination: {
                    total_pages: total_pages,
                    current_page: current_page,
                    count_total: total_count,
                    count_results: length
                },
                records: data
            }
        end

        # Ussage example
        # tasks = Task
        # .joins(:detail)
        # .page(query[:pagination][:page])
        # .per(query[:pagination][:perPage])
        # 
        # response_message = LC::Response.search(tasks)
        # respond_with_successful(response_message)
        # DEPRECATED: Use LesliServices instead
        def self.search payload
            {
                columns: payload.first.as_json.keys,
                records: payload
            }
        end


        # Response template for service objects
        # DEPRECATED: Use LesliServices instead
        def self.service successful, payload=nil
            return OpenStruct.new({ successful?: successful, success?: successful, payload: payload }) if successful == true
            return OpenStruct.new({ successful?: successful, success?: successful, error: payload })
        end
    end
end
