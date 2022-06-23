# =begin

# Copyright (c) 2020, all rights reserved.

# All the information provided by this platform is protected by international laws related  to
# industrial property, intellectual property, copyright and relative international laws.
# All intellectual or industrial property rights of the code, texts, trade mark, design,
# pictures and any other information belongs to the owner of this platform.

# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.

# For more information read the license file including with this software.

# // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
# // ·

# =end

# include helpers, configuration & initializers for request tests
require "lesli_request_helper"

RSpec.describe "Tests for Lesli 3", :unless => defined?(DeutscheLeibrenten) do

    describe "DEL:/administration/users/:id.json with user with invalid permissions", type: :request do
        include_context "request user authentication"

        it "is expected to respond with unauthorized when is deleting a user" do
            admin_user = FactoryBot.create(:user)
            limited_user = FactoryBot.create(:user, role_name: "limited")

            sign_in limited_user

            delete "/administration/users/#{admin_user.id}.json"

            # shared examples
            expect_response_with_unauthorized
        end

        it "is expected to delete a user from db" do
            limited_user = FactoryBot.create(:user, role_name: "limited")

            delete "/administration/users/#{limited_user.id}.json"

            # shared examples
            expect_response_with_successful
        end
    end

end
