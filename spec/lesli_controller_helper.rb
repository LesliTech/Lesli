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

require 'faker'
require 'rails_helper'
require 'support/helpers/response_helper'


# · Authentication context
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
RSpec.shared_context 'controller user authentication' do 

    # Creates a new valid user session
    before :each do
        request.env["HTTP_ACCEPT"] = 'application/json'
        @current_user = User.first
        sign_in(@current_user)
    end

end


# · Configuration
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
RSpec.configure do |config|

    # Include devise helpers to be able to login on test runtime
    config.include Devise::Test::IntegrationHelpers
    config.include Devise::Test::ControllerHelpers, type: :controller

    # Include helper methods 
    config.include ResponseHelpers

end
