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

RSpec.describe "GET:/administration/users/:id/sessions.json", type: :request do
    include_context "user authentication"

    before(:all) do
        get "/administration/users/#{@user.id}/sessions.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with user session" do
        expect(@response_body_data).to be_a(Hash)
    
        expect(@response_body_data).to have_key("pagination")
        expect(@response_body_data["pagination"]).to be_a(Hash)

        expect(@response_body_data).to have_key("records")
        expect(@response_body_data["records"]).to be_an(Array)
    end

    it "is expected that the pagination is valid" do
        expect(@response_body_data["pagination"]).to have_key("total_pages")
        expect(@response_body_data["pagination"]["total_pages"]).to be_a(Numeric)

        expect(@response_body_data["pagination"]).to have_key("current_page")
        expect(@response_body_data["pagination"]["current_page"]).to be_a(Numeric)

        expect(@response_body_data["pagination"]).to have_key("count_total")
        expect(@response_body_data["pagination"]["count_total"]).to be_a(Numeric)

        expect(@response_body_data["pagination"]).to have_key("count_results")
        expect(@response_body_data["pagination"]["count_results"]).to be_a(Numeric)
    end

end

RSpec.describe "GET:/administration/users/:id/sessions.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @new_user = create(:user)
        @new_user.confirm

        sign_in @new_user

        get "/administration/users/#{@user.id}/sessions.json"
    end

    include_examples "unauthorized standard json response"

    it "is expected to respond with unauthorized" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
    end
end