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

# When user is authenticated
RSpec.describe "Not found - GET:/404 when user is authenticated", type: :request do
    include_context 'user authentication'
    before(:all) { get "/404.json" }

    include_examples 'not found standard json response'
end


# When user is NOT authenticated
RSpec.describe "Not found - GET:/404 when user is NOT authenticated", type: :request do
    before(:all) { get "/404.json" }

    include_examples 'not found standard json response'
end

# RSpec.describe "Not found - GET:/404", type: :request do
#     before(:all) do
#         get "/administration/#{ Faker::Lorem.word }/#{ Faker::Lorem.word }"
#     end
#     it "is expected to respond with information of a page not found" do
#         expect(@response_body["error"]).to be_a(Hash)
#         expect(@response_body["error"]).to have_key("message")
#         expect(@response_body["error"]["message"]).to be_a(String)
#         expect(@response_body["error"]).to have_key("details")
#         expect(@response_body["error"]["details"]).to be_an(Array)
#     end
# end
