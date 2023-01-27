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
