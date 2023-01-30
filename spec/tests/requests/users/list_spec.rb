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

            expect(response_body.first).to have_key("email")
            expect(response_body.first["email"]).to be_a(String)

            expect(response_body.first).to have_key("name")
            expect(response_body.first["name"]).to be_a(String)

        end

        it "is expected to respond with total of user with a specific role" do

            ["owner", "sysadmin", "api", "guest", "limited"].each do |role|

                get "/administration/users/list.json?role=#{role}"

                expect_response_with_successful

                users_by_role_in_database = @current_user.account.users.joins(:roles).where("roles.name = ?", role).count

                expect(response_body.size).to eql(users_by_role_in_database)

            end
        end

        it "is expected to respond with total of user with a specific roles" do

            get "/administration/users/list.json?role=owner,sysadmin"

            expect_response_with_successful

            users_by_role_in_database = @current_user.account.users.joins(:roles).where("roles.name in ('owner','sysadmin')").count

            expect(response_body.size).to eql(users_by_role_in_database)

        end
    end
end
