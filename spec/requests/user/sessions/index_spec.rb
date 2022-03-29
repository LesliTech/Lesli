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


require 'lesli_request_helper'


RSpec.describe "GET:/administration/users/:id/sessions.json", type: :request do
    include_context 'request user authentication'

    before do
        get "/administration/users/#{@current_user.id}/sessions.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected to respond with user session" do
        expect(response_data).to be_a(Hash)
    
        expect(response_data).to have_key("pagination")
        expect(response_data["pagination"]).to be_a(Hash)

        expect(response_data).to have_key("records")
        expect(response_data["records"]).to be_an(Array)
    end

    it "is expected that the pagination is valid" do
        expect(response_data["pagination"]).to have_key("total_pages")
        expect(response_data["pagination"]["total_pages"]).to be_a(Numeric)

        expect(response_data["pagination"]).to have_key("current_page")
        expect(response_data["pagination"]["current_page"]).to be_a(Numeric)

        expect(response_data["pagination"]).to have_key("count_total")
        expect(response_data["pagination"]["count_total"]).to be_a(Numeric)

        expect(response_data["pagination"]).to have_key("count_results")
        expect(response_data["pagination"]["count_results"]).to be_a(Numeric)
    end

end

RSpec.describe "GET:/administration/users/:id/sessions.json", type: :request do
    include_context 'request user authentication'

    it "is expected to respond with unauthorized standard json response" do
        @new_user = create(:user, role_name: "limited")

        sign_in @new_user
        puts @current_user.id
        puts @new_user.id
        get "/administration/users/#{@current_user.id}/sessions.json"

        expect_json_response_unauthorized
    end
end
