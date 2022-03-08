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

require "lesli_request_helper"

RSpec.describe 'GET:/administration/role_descriptors.json', type: :request do

    include_context "request user authentication"

    before(:each) do
        @default_role_descriptors = 3
        create_list(:role_descriptor, 5, account: @current_user.account)
        @expect_count = @current_user.account.role_descriptors.count - @default_role_descriptors
        get('/administration/role_descriptors.json?perPage=1000') 
    end

    it "is expected to respond with role descriptors" do
        expect_json_response_successful
        expect(response_data).to be_a(Hash)
        expect(response_data).to have_key("pagination")
        expect(response_data).to have_key("records")
    end

    it "is expected to respond with pagination" do
        expect_json_response_successful
        expect(response_data["pagination"]).to be_a(Hash)
        expect(response_data["pagination"]).to have_key("total_pages")
        expect(response_data["pagination"]["total_pages"]).to be_a(Numeric)

        expect(response_data["pagination"]).to have_key("current_page")
        expect(response_data["pagination"]["current_page"]).to be_a(Numeric)

        expect(response_data["pagination"]).to have_key("count_total")
        expect(response_data["pagination"]["count_total"]).to be_a(Numeric)

        expect(response_data["pagination"]).to have_key("count_results")
        expect(response_data["pagination"]["count_results"]).to be_a(Numeric)
    end

    it 'is expected to respond with records' do
        expect_json_response_successful
        expect(response_data["records"]).to be_an(Array)
        expect(response_data['records'].length).to eql(@expect_count)

        # Validate last record
        expect(response_data["records"].first).to have_key("id")
        expect(response_data["records"].first["id"]).to be_a(Numeric)

        expect(response_data["records"].first).to have_key("name")
        expect(response_data["records"].first["name"]).to be_a(String)

        expect(response_data["records"].first).to have_key("description")
        expect(response_data["records"].first["description"]).to be_a(String)

        expect(response_data["records"].first).to have_key("created_at")
        expect(response_data["records"].first["created_at"]).to be_a(String)

        expect(response_data["records"].first).to have_key("actions_length")
        expect(response_data["records"].first["actions_length"]).to be_a(Numeric)

        expect(response_data["records"].first).to have_key("created_at_date")
        expect(response_data["records"].first["created_at"]).to be_a(String)

        expect(response_data["records"].first).to have_key("updated_at_date")
        expect(response_data["records"].first["updated_at"]).to be_nil
    end

end
