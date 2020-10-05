=begin

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

module Application

    module Logger
        extend ActiveSupport::Concern

        included do
        end

        def responseWithSuccessful(data = nil)
            LC::Debug.simple_msg "DEPRECATED: use respond_with_successful instead"
            respond_with_successful(data)
        end
    
        def responseWithError(message = "", details = [])
            LC::Debug.simple_msg "DEPRECATED: use respond_with_error instead"
            respond_with_error(message, details)
        end
    
        def responseWithNotFound
            LC::Debug.simple_msg "DEPRECATED: use respond_with_not_found instead"
            respond_with_not_found()
        end
    
        def responseWithUnauthorized(detail = {})
            LC::Debug.simple_msg "DEPRECATED: use respond_with_unauthorized instead"
            respond_with_unauthorized(detail)
        end

        def respond_with_pagination data
            LC::Debug.simple_msg "DEPRECATED: use LC::Response.pagination in combination with respond_with_successful instead"
            respond_with_successful(data)
        end

        # Deprecated method used to log user messages logs
        def log_activity description=nil
            LC::Debug.msg "DEPRECATED: Use log_user_commens or current_user.logs.create instead"
            LC::Debug.msg session[:session_id]
            log_user_comments(description)
        end

    end

end
