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

RSpec.describe "PUT:/administration/users/:id/actions/email.json", type: :request do
    include_context "request user authentication"

    before do
        @new_email = Faker::Internet.email

        put("/administration/users/#{@current_user.id}/actions/email.json", params: {
            user: { email: @new_email }
        })
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
        expect(response_data).to be_nil
    end
end

RSpec.describe "PUT:/administration/users/:id/actions/email.json", type: :request do
    include_context "request user authentication"

    let(:new_user) do
        @new_user = User.new(attributes_for(:user))
        @role = Role.find_by(name: "limited")

        @new_user.confirm
        @new_user.save!

        @new_user.user_roles.create!({ role: @role })
        @new_user
    end

    before do
        @new_email = Faker::Internet.email

        sign_in new_user

        put("/administration/users/#{@current_user.id}/actions/email.json", params: {
            user: { email: @new_email }
        })
    end

    it "is expected to respond with unauthorized standard json response" do
        expect_json_response_unauthorized
    end
end

RSpec.describe "PUT:/administration/users/:id/actions/email.json", type: :request do
    include_context "request user authentication"

    before do
        # this Id does not exist, so, should return with not found
        @invalid_user_id = create(:user).id + 1

        put("/administration/users/#{@invalid_user_id}/actions/email.json", params: {
            user: { email: Faker::Internet.email }
        })
    end

    it "is expected to respond with not found standard json response" do
        expect_json_response_error
    end
end


RSpec.describe "PUT:/administration/users/:id/actions/email.json", type: :request do
    before do
        @new_user = create(:user)

        put("/administration/users/#{@new_user.id}/actions/email.json", params: {
            user: { email: "" }
        })
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to("/login")
    end

end
