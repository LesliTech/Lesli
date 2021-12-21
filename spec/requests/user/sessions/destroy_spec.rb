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

RSpec.describe "DELETE:/administration/users/:id/sessions.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @user.sessions.create!({})

        # get the id of the session created above
        @last_id_session = @user.sessions.last.id

        delete "/administration/users/#{@user.id}/sessions/#{@last_id_session}.json"
    end

    include_examples "successful standard json response"

    it "is expected to destroy the session of the user authenticated" do
        expect(@response_body_data).to be_nil
        expect(@user.sessions.find_by(id: @last_id_session)).to be_nil
    end
end

RSpec.describe "DELETE:/administration/users/:id/sessions.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @user.sessions.create!({})

        # get an ID that does not exist in the user sessions
        @invalid_id = @user.sessions.last.id + 1

        delete "/administration/users/#{@user.id}/sessions/#{@invalid_id}.json"
    end

    include_examples "not found standard json response"

    it "is expected to return with error when an invalid session id is sent" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end

RSpec.describe "DELETE:/administration/users/:id/sessions.json", type: :request do
    include_context "user authentication"

    before(:all) do
        # create a session for the current user
        @user.sessions.create!({})
        @last_id_session = @user.sessions.last.id

        # create a new user to test that a user cannot destroy sessions that are not his
        @new_user = User.new(attributes_for(:user))
        @new_user.confirm
        @new_user.save!
        
        sign_in @new_user

        delete "/administration/users/#{@user.id}/sessions/#{@last_id_session}.json"
    end

    include_examples "unauthorized standard json response"

    it "is expected to return with error when an invalid session id is sent" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
    end
end