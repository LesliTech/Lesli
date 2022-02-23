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

class AboutsController < ApplicationLesliController
    skip_before_action :authorize_privileges, only: []

    def system_requirements
    end

    def dashboard
    end

    def version

        @aboutengines = LC::System::Info.revisions().map do |engine|
            engine[1][:name] = engine[0].titleize()
            engine[1][:image] = "#{ engine[0] }/#{ engine[0].sub('cloud_', '') }-logo.svg"
            if engine[0] == "cloud_dispatcher"
                engine[1][:image] = "lesli/brand/app-icon.svg"
            end
            engine
        end

        respond_to do |format|
            format.html {}
            format.json { respond_with_successful(@aboutengines) }
        end
        
    end

    def show
    end

end
