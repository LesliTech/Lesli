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

RSpec.describe "POST:/administration/users/:id/resources/lock.json", type: :request do
    include_context "request user authentication"

    # this helper will executed only when is called (with "user") and the value won't change
    let(:user){ User.find(@current_user.id) }

    before do
        # We ensure that the user is active
        @current_user.update(active: true)

        post "/administration/users/#{@current_user.id}/resources/lock.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected that the data property is nill" do
        expect(response_data).to be_nil
    end

    it "is expected that the user is not active anymore" do
        expect(user.active).to be_falsey
    end

    # it "is expected that the user has no sessions" do
    #     expect(user.sessions).to be_empty
    # end
end

RSpec.describe "POST:/administration/users/:id/resources/lock.json", type: :request do
    include_context "request user authentication"

    before do
        #Should be at least one user in the database
        create(:user)

        # Get an Id that does not exist
        @invalid_user_id = User.all.order(id: :asc).last["id"] + 1

        post "/administration/users/#{@invalid_user_id}/resources/lock.json"
    end

    it "is expected to respond with not found standard json response" do
        expect_json_response_error
    end
end

RSpec.describe "POST:/administration/users/:id/resources/lock.json", type: :request do

    before do
        #Should be at least one user in the database
        create(:user)

        # Get any user Id
        @user_id = User.all.order(id: :asc).last["id"]

        post "/administration/users/#{@user_id}/resources/lock.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to("/login")
    end
end
