=begin

Copyright (c) 2022, all rights reserved.

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

RSpec.describe 'GET:/administration/roles/:id.json', type: :request do

    include_context "request user authentication"

    it "is expected to respond with a valid role created" do

        role = FactoryBot.create(:role)

        get("/administration/roles/#{role.id}.json")


        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key("id")
        expect(response_body["id"]).to be >= 1
        expect(response_body["id"]).to eql(role.id)

        expect(response_body).to have_key("name")
        expect(response_body["name"]).to be_a(String)
        expect(response_body["name"]).to eql(role.name)

        expect(response_body).to have_key("active")
        expect(response_body["active"]).to be_truthy

        expect(response_body).to have_key("default_path")
        expect(response_body["default_path"]).to be_nil

        expect(response_body).to have_key("only_my_data")
        expect(response_body["only_my_data"]).to be_falsey

        expect(response_body).to have_key("object_level_permission")
        expect(response_body["object_level_permission"]).to be_a(Numeric)
        expect(response_body["object_level_permission"]).to eql(role.object_level_permission)

        expect(response_body).to have_key("created_at")
        expect(response_body["created_at"]).to be_a(String)

        expect(response_body).to have_key("updated_at")
        expect(response_body["updated_at"]).to be_a(String)

    end

    it "is expected to respond with 404 when a role does not exist" do

        get("/administration/roles/#{ 0 }.json")

        # shared examples
        expect_response_with_not_found

        expect(response_body).to have_key("message")
        expect(response_body["message"]).to be_a(String)
        
    end

end
