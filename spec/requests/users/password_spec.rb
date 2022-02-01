=begin

Copyright (c) 2020, all rights reserved.

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


RSpec.describe 'POST:/password', type: :request do
    #include_context 'user authentication'

    before(:all) do
        @user = User.find_by(:email => "test@lesli.cloud")
        post("/password", params: {
            user: {
                email: @user.email
            }
        })
    end

    #include_examples 'successful standard json response'

    it 'is expected to create a password reset token' do
        
    end
end

RSpec.describe "POST:/administration/users/:id/resources/password.json", type: :request do
    include_context "request user authentication"

    # this helper will executed only when is called and the value won't change
    let(:password_expiration_at) { User.where("id = ?", @current_user.id).select("password_expiration_at") }

    before do
        post "/administration/users/#{@current_user.id}/resources/password.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected that the user's password is expired" do
        expect(password_expiration_at).not_to be_empty
        expect(password_expiration_at).not_to be_nil
    end
end

RSpec.describe "POST:/administration/users/:id/resources/password.json", type: :request do
    include_context "request user authentication"

    # this helper will executed only when is called and the value returned won't change
    let(:new_user) do
        @new_user = User.new(attributes_for(:user))
        @role = Role.find_by(name: "limited")

        @new_user.confirm
        @new_user.save!

        @new_user.user_roles.create!({ role: @role })
        @new_user
    end

    before do
        # this user has limited privileges, so, should return with unauthorized
        sign_in new_user
        post "/administration/users/#{@current_user.id}/resources/password.json"
    end

    it "is expected to respond with unauthorized standard json response" do
        expect_json_response_unauthorized
    end
end

RSpec.describe "POST:/administration/users/:id/resources/password.json", type: :request do
    include_context "request user authentication"

    # this helper will executed only when is called and the value returned won't change
    let(:invalid_user_id) { @invalid_id = create(:user).id + 1 }

    before do
        # the Id sent does not exist in the db, so should return with not found
        post "/administration/users/#{invalid_user_id}/resources/password.json"
    end

    it "is expected to respond with not found standard json response" do
        expect_json_response_error
    end
end

RSpec.describe "POST:/administration/users/:id/resources/password.json", type: :request do
    # this helper will executed only when is called and the value returned won't change
    let(:user_id) { @user_id = create(:user).id }

    before { post "/administration/users/#{user_id}/resources/password.json" }

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to("/login")
    end
end


