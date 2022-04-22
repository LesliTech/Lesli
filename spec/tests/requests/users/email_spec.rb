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

RSpec.describe "PUT:/administration/users/:id/actions/email.json", type: :request do
    include_context "request user authentication"

    # helper methods
    let!(:create_limited_user) { FactoryBot.create(:user, role_name: "limited") }

    # test cases
    it "is expected to respond with successful standard json response" do
        @new_email = Faker::Internet.email

        put("/administration/users/#{@current_user.id}/actions/email.json", params: {
            user: { email: @new_email }
        })
        
        expect_json_response_successful
        expect(response_data).to be_nil
    end

    it "is expected to respond with unauthorized standard json response" do
        new_email = Faker::Internet.email
        new_user = create_limited_user

        sign_out @current_user
        sign_in new_user

        put("/administration/users/#{@current_user.id}/actions/email.json", params: {
            user: { email: new_email }
        })

        # shared examples
        expect_json_response_unauthorized
    end

    it "is expected to respond with not found standard json response" do
         # this Id does not exist, so, should return with not found
         invalid_user_id = create_limited_user.id + 1

         put("/administration/users/#{invalid_user_id}/actions/email.json", params: {
             user: { email: Faker::Internet.email }
         })

        # shared examples
        expect_json_response_error
    end

    it "is expected to redirect to login when user is not authenticated" do
        new_user =  create_limited_user

        sign_out @current_user

        put("/administration/users/#{new_user.id}/actions/email.json", params: {
            user: { email: "" }
        })

        expect(response).to redirect_to("/login")
    end
end
