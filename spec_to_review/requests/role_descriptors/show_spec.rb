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


RSpec.describe "GET:/administration/role_descriptors/:id.json", type: :request do

    include_context "user authentication"

    before(:all) do
        @role_descriptor = create(:role_descriptor, account: @user.account)
        get "/administration/role_descriptors/#{@role_descriptor.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with a role descriptor" do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to eql(@role_descriptor.id)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@role_descriptor.name)

        expect(@response_body_data).to have_key("description")
        expect(@response_body_data["description"]).to be_a(String)
        expect(@response_body_data["description"]).to eql(@role_descriptor.description)

        expect(@response_body_data).to have_key("role_descriptors_id")
        expect(@response_body_data["role_descriptors_id"]).to be_nil

        expect(@response_body_data).to have_key("created_at_date")
        expect(@response_body_data["created_at_date"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at_date")
        expect(@response_body_data["updated_at_date"]).to be_a(String)
    end

end

RSpec.describe "GET:/administration/role_descriptors/:id.json", type: :request do

    include_context "user authentication"

    before(:all) do
        # Look for an ID that does not exist
        @invalid_id = create(:role_descriptor, account: @user.account).id + 1

        get "/administration/role_descriptors/#{@invalid_id}.json"
    end

    include_examples "not found standard json response"    

    it "is expected to respond with error properties when an invalid ID is sent" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end