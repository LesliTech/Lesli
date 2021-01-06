module CloudObject
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
    class FilesController < ApplicationLesliController
        include Interfaces::Controllers::Files
        
        before_action :show_deprecated_message

        def show_deprecated_message
            LC::Debug.msg "DEPRECATED: Your controller must inherit from ApplicationLesliController and include Interfaces::Controllers::Files instead"
        end
    end
end
