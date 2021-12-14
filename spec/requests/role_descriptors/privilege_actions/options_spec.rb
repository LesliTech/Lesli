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


RSpec.describe "GET:/administration/role_descriptors/privilege_actions/options.json", type: :request do

    include_context "user authentication"

    before(:all) do 
        get "/administration/role_descriptors/privilege_actions/options.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with privilege actions options" do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("system_controllers")
        expect(@response_body_data["system_controllers"]).to be_an(Array)

        expect(@response_body_data).to have_key("categories")
        expect(@response_body_data["categories"]).to be_an(Array)
    end
end