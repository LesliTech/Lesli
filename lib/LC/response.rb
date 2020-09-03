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

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.
@todo       Separate settings from account

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

    end
end
