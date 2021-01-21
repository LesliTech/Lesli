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

require 'rails_helper'
require 'spec_helper'
require 'byebug'


2.times do 
    RSpec.describe 'GET:/users in loop', type: :request do
        include_context 'user authentication'

            before(:all) do
                post("/administration/users.json", params: {
                    user: {
                        email: Faker::Internet.email,
                        roles_id: 7,
                        active: true,
                        detail_attributes: {
                            salutation: "mr",
                            first_name: "luis",
                            last_name: "donis"
                        }
                    }
                })
            end

            include_examples 'successful standard json response'

            it 'is expected to test users in a loop' do

            end

    end
end
