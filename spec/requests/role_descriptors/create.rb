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


RSpec.describe 'POST:/administration/role_descriptors.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @name = Faker::Lorem.word
        @description = Faker::Lorem.paragraph

        post('/administration/role_descriptors.json', params: {
            name: @name,
            description: @description
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create a new role descriptor' do
        expect(@response_body['data']['name']).to eql(@name)
        expect(@response_body['data']['description']).to eql(@description)
    end

end
