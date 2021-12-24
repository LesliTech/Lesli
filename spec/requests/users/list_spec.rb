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
require 'spec_helper'   
require 'byebug'


RSpec.describe "GET:/administration/users/list.json", type: :request do
    include_context 'request user authentication'

    before do
        get "/administration/users/list.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected to respond with an array of users" do
        expect(response_data).to be_an(Array)
        expect(response_data.length).to be >= 1

        expect(response_data.first).to have_key("id")
        expect(response_data.first["id"]).to be_a(Numeric)
        expect(response_data.first["id"]).to be >= 1

        expect(response_data.first).to have_key("active")
        expect(response_data.first["active"]).to be_in([true, false])

        expect(response_data.first).to have_key("email")
        expect(response_data.first["email"]).to be_a(String)

        expect(response_data.first).to have_key("editable")
        expect(response_data.first["editable"]).to be_in([true, false])

        expect(response_data.first).to have_key("name")
        expect(response_data.first["name"]).to be_a(String)
    end

    it "is expected that the user has a valid role" do
        expect(response_data.first).to have_key("roles")
        expect(response_data.first["roles"]).to be_an(Array)
        expect(response_data.first["roles"].length).to be >= 1

        expect(response_data.first["roles"].first).to be_a(Hash)
        expect(response_data.first["roles"].first).to have_key("id")
        expect(response_data.first["roles"].first["id"]).to be_a(Numeric)
        
        expect(response_data.first["roles"].first).to have_key("name")
        expect(response_data.first["roles"].first["name"]).to be_a(String)

        expect(response_data.first["roles"].first).to have_key("code")
        expect(response_data.first["roles"].first["code"]).to be_a(String)

        expect(response_data.first["roles"].first).to have_key("active")
        expect(response_data.first["roles"].first["active"]).to be_in([true, false])

        expect(response_data.first["roles"].first).to have_key("default_path") # this prop is nil in some cases and in others string

        expect(response_data.first["roles"].first).to have_key("only_my_data")
        expect(response_data.first["roles"].first["only_my_data"]).to be_in([true, false])

        expect(response_data.first["roles"].first).to have_key("object_level_permission")
        expect(response_data.first["roles"].first["object_level_permission"]).to be_a(Numeric)

        expect(response_data.first["roles"].first).to have_key("deleted_at")
        expect(response_data.first["roles"].first["deleted_at"]).to be_nil

        expect(response_data.first["roles"].first).to have_key("created_at")
        expect(response_data.first["roles"].first["created_at"]).to be_a(String)

        expect(response_data.first["roles"].first).to have_key("updated_at")
        expect(response_data.first["roles"].first["updated_at"]).to be_a(String)

        expect(response_data.first["roles"].first).to have_key("accounts_id")
        expect(response_data.first["roles"].first["accounts_id"]).to be_a(Numeric)
    end
end

RSpec.describe "GET:/administration/users/list.json", type: :request do
    let(:login) { "/login?r=/administration/users/list.json" }

    before(:all) do
        get "/administration/users/list.json"
    end

    it "is expecte to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end