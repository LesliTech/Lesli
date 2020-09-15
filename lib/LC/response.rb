=begin

Lesli

Copyright (c) 2020, all rights reserved.

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


        # Response template for service objects
        def self.service success, payload
            return OpenStruct.new({ success?: success, payload: payload }) if success == true
            return OpenStruct.new({ success?: success, error: payload })
        end

    end
end
