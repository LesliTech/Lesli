=begin

Copyright (c) 2021, all rights reserved.

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



RSpec.describe 'POST:/invite', type: :request do
    include_context 'user authentication'

    before(:all) do
        post("/invite.json", params: {
            invite: {
                email: Faker::Internet.email,
                telephone: Faker::PhoneNumber.phone_number,
                full_name: Faker::Name.name,
                note: Faker::Lorem.paragraph
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create an invitation request' do
        expect(@response_body["data"]["id"]).to be > 0
    end

end
