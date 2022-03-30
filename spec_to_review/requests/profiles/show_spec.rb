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


RSpec.describe "GET:/administration/profile", type: :request do
    include_context "user authentication"

    before(:all) { get "/administration/profile.json" }

    include_examples "successful standard json response"

    it "is expected to respond with current user profile" do
        expect(@response_body_data).to be_a(Hash)
    end

    it "is expected that the response has all the correct keys and data types" do
        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to eql(@user.id)
        
        expect(@response_body_data).to have_key("email")
        expect(@response_body_data["email"]).to be_a(String)
        expect(@response_body_data["email"]).to eql(@user.email)

        expect(@response_body_data).to have_key("active")
        expect(@response_body_data["active"]).to be_truthy

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("editable_security")
        expect(@response_body_data["editable_security"]).to be_truthy

        expect(@response_body_data).to have_key("roles")
        expect(@response_body_data["roles"]).to be_an(Array)
        expect(@response_body_data["roles"].length).to be > 0

        expect(@response_body_data).to have_key("full_name")
        expect(@response_body_data["full_name"]).to be_a(String)

        expect(@response_body_data).to have_key("detail_attributes")
        expect(@response_body_data["detail_attributes"]).to be_a(Hash)

        expect(@response_body_data["detail_attributes"]).to have_key("title")
        expect(@response_body_data["detail_attributes"]["title"]).to be_nil

        expect(@response_body_data["detail_attributes"]).to have_key("salutation")
        expect(@response_body_data["detail_attributes"]["salutation"]).to be_a(String)

        expect(@response_body_data["detail_attributes"]).to have_key("first_name")
        expect(@response_body_data["detail_attributes"]["first_name"]).to be_a(String)

        expect(@response_body_data["detail_attributes"]).to have_key("last_name")
        expect(@response_body_data["detail_attributes"]["last_name"]).to be_a(String)

        expect(@response_body_data["detail_attributes"]).to have_key("telephone")
        expect(@response_body_data["detail_attributes"]["telephone"]).to be_nil

        expect(@response_body_data["detail_attributes"]).to have_key("address")
        expect(@response_body_data["detail_attributes"]["address"]).to be_nil

        expect(@response_body_data["detail_attributes"]).to have_key("work_city")
        expect(@response_body_data["detail_attributes"]["work_city"]).to be_nil

        expect(@response_body_data["detail_attributes"]).to have_key("work_region")
        expect(@response_body_data["detail_attributes"]["work_region"]).to be_nil

        expect(@response_body_data["detail_attributes"]).to have_key("work_address")
        expect(@response_body_data["detail_attributes"]["work_address"]).to be_nil
    end
end

RSpec.describe "GET:/administration/profile", type: :request do
    let!(:login) { "/login?r=/administration/profile.json" }
    before(:all) { get "/administration/profile.json" }

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end