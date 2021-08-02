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


RSpec.describe 'PUT:/administration/role_descriptors/4.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @name = Faker::Lorem.word
        @description = Faker::Lorem.paragraph

        put('/administration/role_descriptors/4.json', params: {
            role_descriptor: {
                name: @name,
                description: @description
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to update a role descriptor' do
        expect(@response_body['data']['name']).to eql(@name)
        expect(@response_body['data']['description']).to eql(@description)
    end

end

RSpec.describe 'POST:/administration/role_descriptors/4/privilege_actions.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        categories = ["index", "create", "update", "show", "destroy", "search"]
        @category = categories[Faker::Number.between(from: 0, to: categories.size)]
        @system_controller_action = SystemController::Action.order(Arel.sql('RANDOM()')).first

        post('/administration/role_descriptors/4/privilege_actions.json', params: {
            role_descriptor_privilege_action: {
                status: true,
                category: @category,
                system_controller_actions_id: @system_controller_action.id
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to update a role descriptor' do
        expect(@response_body['data']['status']).to eql(true)
        expect(@response_body['data']['category']).to eql(@category)
        expect(@response_body['data']['system_controller_actions_id']).to eql(@system_controller_action.id)
    end

end
