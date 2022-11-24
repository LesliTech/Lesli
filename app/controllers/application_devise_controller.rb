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

class ApplicationDeviseController < ActionController::Base
    include Interfaces::Application::Responder
    include Interfaces::Application::Requester
    include Interfaces::Application::Logger
    
    layout "layouts/application-public"

    before_action :set_locale

    def initialize
        @account = { 
            company: {
                name: Rails.application.config.lesli.dig(:account, :name)
            }
        }
        super
    end

end
    