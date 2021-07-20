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

        # first create some shortcuts so we have something to delete xD
        @shortcut = @user.shortcuts.create({
            name: Faker::Internet.domain_name, 
            url: Faker::Internet.url(host: 'example.com')
        })

        # delete the just created shortcut
        delete "/administration/users/#{@user.id}/shortcuts/#{@shortcut.id}.json"

    end

    include_examples 'successful standard json response'

    it 'is expected to delete a specific shortcut' do
        expect(@response_body['successful']).to eql(true)
    end

end
