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


require 'lesli_request_helper'
require 'spec_helper'   
require 'byebug'


RSpec.describe "POST:/administration/users/:id/resources/logout.json", type: :request do
    include_context "request user authentication"

    # this helper will executed only when is called (with "user_sessions") and the value won't change
    let(:new_user){ create(:user) }
    let(:user_sessions) { User.joins(:sessions).where("users_id = ?", new_user.id) }

    before do
        post "/administration/users/#{new_user.id}/resources/logout.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected to logout the current user" do
        expect(response_data).to be_a(Numeric)
        # We ensure that the session is closed
        expect(response_data).to eql(0)
    end

    it "is expected that the user has no sessions anymore" do
        expect(user_sessions).to be_empty
    end
end

RSpec.describe "POST:/administration/users/:id/resources/logout.json", type: :request do
    include_context "request user authentication"

    before do
        # We create a new user with limited privileges
        @new_user = User.new(attributes_for(:user))
        @role = Role.find_by(name: "limited")

        @new_user.confirm
        @new_user.save!

        @new_user.user_roles.create!({ role: @role })

        sign_in @new_user

        post "/administration/users/#{@current_user.id}/resources/logout.json"
    end

    it "is expected to respond with unauthorized standard json response" do
        expect_json_response_unauthorized
    end
end


RSpec.describe "POST:/administration/users/:id/resources/logout.json", type: :request do
    before do
        # We test that a user not authenticated cannot delete a session
        @new_user = User.new(attributes_for(:user))
        @new_user.confirm
        @new_user.save!


        post "/administration/users/#{@new_user.id}/resources/logout.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to("/login")
    end
end
