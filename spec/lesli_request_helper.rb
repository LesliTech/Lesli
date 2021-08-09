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
RSpec.shared_context 'request user authentication' do 

    # Creates a new valid user session
    before(:each) do
        @current_user = User.find_by(email: Rails.application.config.lesli_settings["account"]["user"]["email"])
        sign_in @current_user
    end

end


# · Configuration
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
RSpec.configure do |config|

    # Include devise helpers to be able to login on test runtime
    config.include Devise::Test::IntegrationHelpers

    # Include helper methods 
    config.include ResponseHelpers

end


# · Validations to execute tests
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~

# Validate that at least there are one user in the database
if ::User.all.count < 1
    LC::Debug.error("Not all the test users were loaded")
    exit;
end

# Validate that the test user exists in the database 
if ::User.where(:email => Rails.application.config.lesli_settings["account"]["user"]["email"]).blank?
    LC::Debug.error("No test user found")
    exit;
end

# Notify to user...
LC::Debug.info(
    "Running RSpec tests...", 
    "For a better result run test over a clean database", 
    "You can use rake dev:db:reset test before rspec."
)
