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

        it "is expected that the index includes users with a valid role" do
            get "/administration/users.json"

            # shared examples
            expect_response_with_pagination

            # custom specs
            expect(response_body["records"].first).to have_key("rolenames")
            expect(response_body["records"].first["rolenames"]).to be_an(String)

        end
    end
end
