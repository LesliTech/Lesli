=begin

Copyright (c) 2021, all rights reserved.

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


require 'rails_helper'
require 'spec_helper'   
require 'byebug'

RSpec.describe "POST:/login.json", type: :request do

    before(:all) do
        # Create a valid user session
        @account = create(:account)
        @role = Role.first

        @new_user = User.new(attributes_for(:user))
        @new_user.account = @account

        @new_user.confirm
        @new_user.save!

        @new_user.user_roles.create!({ role: @role })

        post "/login.json", params: { user: { email: @new_user.email, password: @new_user.password } }
    end

    include_examples "successful standard json response"

    it "is expected to respond with a user logged" do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("default_path")
        expect(@response_body_data["default_path"]).to be_a(String)
    end

    it "is expected that the default path is onboarding" do
        expect(@response_body_data["default_path"]).to eql("/onboarding")
    end
end

RSpec.describe "POST:/login.json", type: :request do
    before(:all) do
        post "/login.json", params: { user: { email: "", password: "" } }
    end

    include_examples "error standard json response"

    it "is expected to respond with error when the credentials are invalid" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
    end
end

RSpec.describe "POST:/login.json", type: :request do
    include_context "user authentication"

    before(:all) do
        post "/login.json", params: { user: { email: "", password: "" } }
    end

    it "is expected to redirect to '/' route when the user is already logged" do
        expect(response).to redirect_to("/")
    end
end