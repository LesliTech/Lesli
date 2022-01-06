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


# RSpec.describe 'GET:/administration/users/:id/shortcuts.json', type: :request do
#     include_context 'user authentication'
    
#     before(:all) do

#         # first create some shortcuts to have something to list :D
#         @user.shortcuts.create({ name: "projects", url: "/projects"})
#         @user.shortcuts.create({ name: "tasks", url: "/tasks"})

#         # get the list of shortcuts
#         get "/administration/users/#{@user.id}/shortcuts.json"

#     end

#     include_examples 'successful standard json response'

#     it 'is expected to respond with all the shortcuts that belongs to the user' do
#         expect_count = @user.shortcuts.count
#         expect_count = 15 if expect_count > 15 # the api paginates the results
#         expect(@response_body['data']['records'].size).to be >= (expect_count)
#         expect(@response_body['data']['pagination']['count_results']).to eql(expect_count)
#     end
# end
