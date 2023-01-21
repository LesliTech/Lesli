=begin

Copyright (c) 2023, all rights reserved.

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

# include helpers, configuration & initializers for request tests
require "lesli_request_helper"

RSpec.describe "Tests for Lesli 3" do

    describe "GET:/administration/users/list.json", type: :request do
        include_context "request user authentication"

        it "is expected to list users" do
            get "/administration/users/list.json"

            # shared examples
            expect_response_with_successful

            # custom specs
            expect(response_body).to be_an(Array)
            expect(response_body.length).to be >= 1

            expect(response_body.first).to have_key("id")
            expect(response_body.first["id"]).to be_a(Numeric)
            expect(response_body.first["id"]).to be >= 1

            expect(response_body.first).to have_key("active")
            expect(response_body.first["active"]).to be_in([true, false])

            expect(response_body.first).to have_key("email")
            expect(response_body.first["email"]).to be_a(String)

            expect(response_body.first).to have_key("editable")
            expect(response_body.first["editable"]).to be_in([true, false])

            expect(response_body.first).to have_key("name")
            expect(response_body.first["name"]).to be_a(String)

        end

        it "is expected that the user has a valid role" do
            get "/administration/users/list.json"

            # shared examples
            expect_response_with_successful

            # custom specs
            expect(response_body.first).to have_key("roles")
            expect(response_body.first["roles"]).to be_an(Array)
            expect(response_body.first["roles"].length).to be >= 1

            expect(response_body.first["roles"].first).to be_a(Hash)
            expect(response_body.first["roles"].first).to have_key("id")
            expect(response_body.first["roles"].first["id"]).to be_a(Numeric)

            expect(response_body.first["roles"].first).to have_key("name")
            expect(response_body.first["roles"].first["name"]).to be_a(String)

            expect(response_body.first["roles"].first).to have_key("code")
            expect(response_body.first["roles"].first["code"]).to be_a(String)

            expect(response_body.first["roles"].first).to have_key("active")
            expect(response_body.first["roles"].first["active"]).to be_in([true, false])

            expect(response_body.first["roles"].first).to have_key("default_path") # this prop is nil in some cases and in others string

            expect(response_body.first["roles"].first).to have_key("only_my_data")
            expect(response_body.first["roles"].first["only_my_data"]).to be_in([true, false])

            expect(response_body.first["roles"].first).to have_key("object_level_permission")
            expect(response_body.first["roles"].first["object_level_permission"]).to be_a(Numeric)

            expect(response_body.first["roles"].first).to have_key("deleted_at")
            expect(response_body.first["roles"].first["deleted_at"]).to be_nil

            expect(response_body.first["roles"].first).to have_key("created_at")
            expect(response_body.first["roles"].first["created_at"]).to be_a(String)

            expect(response_body.first["roles"].first).to have_key("updated_at")
            expect(response_body.first["roles"].first["updated_at"]).to be_a(String)

            expect(response_body.first["roles"].first).to have_key("accounts_id")
            expect(response_body.first["roles"].first["accounts_id"]).to be_a(Numeric)
        end

    end
end
