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

class ProfilesController < ApplicationLesliController

    # GET /profile
    def show
        respond_to do |format|
            format.html {}
            #format.json { respond_with_successful(current_user.account.users.show(current_user)) }
            format.json { respond_with_successful(current_user.show) }
        end
    end

end
