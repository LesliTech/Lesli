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


RSpec.describe 'GET:/administration/users/:id/shortcuts.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do

        @shortcut = {
            name: Faker::Internet.domain_name, 
            url: Faker::Internet.url(host: 'example.com')
        }

        # get the list of shortcuts
        post "/administration/users/#{@user.id}/shortcuts.json", params: {
            user_shortcut: @shortcut
        }

    end

    include_examples 'successful standard json response'

    it 'is expected to create a new shortcut' do
        expect(@response_body['data']['name']).to eql(@shortcut[:name])
        expect(@response_body['data']['url']).to eql(@shortcut[:url])
    end

end
