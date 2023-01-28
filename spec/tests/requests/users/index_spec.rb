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

    describe "GET:/administration/users.json", type: :request do

        include_context "request user authentication"
=begin
        it "is expected to respond with users index" do

            get "/administration/users.json", params: {
                :perPage => 1000
            }

            expect_response_with_pagination

            expect_count = @current_user.account.users
                .joins(:detail, :user_roles)
                .group("users.id, user_roles.users_id")
                .map(&:id).uniq.count
        end
=end
        it "is expected that the index includes users with a valid role" do
            get "/administration/users.json"

            # shared examples
            expect_response_with_pagination

            # custom specs
            expect(response_body["records"].first).to have_key("roles")
            expect(response_body["records"].first["roles"]).to be_an(Array)
            expect(response_body["records"].first["roles"].length).to be >= 1

            expect(response_body["records"].first["roles"].first).to be_a(Hash)
            expect(response_body["records"].first["roles"].first).to have_key("id")
            expect(response_body["records"].first["roles"].first["id"]).to be_a(Numeric)

            expect(response_body["records"].first["roles"].first).to have_key("name")
            expect(response_body["records"].first["roles"].first["name"]).to be_a(String)

            expect(response_body["records"].first["roles"].first).to have_key("code")
            expect(response_body["records"].first["roles"].first["code"]).to be_a(String)

            expect(response_body["records"].first["roles"].first).to have_key("active")
            expect(response_body["records"].first["roles"].first["active"]).to be_in([true, false])

            expect(response_body["records"].first["roles"].first).to have_key("default_path")

            expect(response_body["records"].first["roles"].first).to have_key("only_my_data")
            expect(response_body["records"].first["roles"].first["only_my_data"]).to be_in([true, false])

            expect(response_body["records"].first["roles"].first).to have_key("object_level_permission")
            expect(response_body["records"].first["roles"].first["object_level_permission"]).to be_a(Numeric)

            expect(response_body["records"].first["roles"].first).to have_key("deleted_at")
            expect(response_body["records"].first["roles"].first["deleted_at"]).to be_nil

            expect(response_body["records"].first["roles"].first).to have_key("created_at")
            expect(response_body["records"].first["roles"].first["created_at"]).to be_a(String)

            expect(response_body["records"].first["roles"].first).to have_key("updated_at")
            expect(response_body["records"].first["roles"].first["updated_at"]).to be_a(String)

            expect(response_body["records"].first["roles"].first).to have_key("accounts_id")
            expect(response_body["records"].first["roles"].first["accounts_id"]).to be_a(Numeric)

        end
    end
end
