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

RSpec.describe "GET:/administration/users/:id/resources/become.json with an user with no privileges", type: :request do
    include_context "request user authentication"

    # helper methods
    # We create a user with no privileges and attempt to become another user
    let(:create_limited_user) { FactoryBot.create(:user, role_name: "limited") }
    let(:create_owner_user) { FactoryBot.create(:user, role_name: "owner") }

    it "with an user with no privileges" do    
        limited_user = create_limited_user
        random_user = User.where("id != ?", limited_user.id).order("random()").first

        get "/administration/users/#{random_user.id}/resources/become.json"

        # shared examples
        expect_json_response_unauthorized
    end

    it "with a user with the wrong email" do
        owner_user = create_owner_user
        sign_in owner_user

        random_user = User.where("id != ?", owner_user.id).order("random()").first

        get "/administration/users/#{random_user.id}/resources/become.json"

        # shared examples
        expect_json_response_unauthorized
    end
end
