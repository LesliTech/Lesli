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


require 'lesli_request_helper'
require 'spec_helper'   
require 'byebug'

RSpec.describe "DELETE:/administration/users/:id/sessions.json", type: :request do
    include_context 'request user authentication'

    before do
        @current_user.sessions.create!({})

        # get the id of the session created above
        @last_id_session = @current_user.sessions.last.id

        delete "/administration/users/#{@current_user.id}/sessions/#{@last_id_session}.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected to destroy the session of the user authenticated" do
        expect(response_data).to be_nil
        expect(@current_user.sessions.find_by(id: @last_id_session)).to be_nil
    end
end

RSpec.describe "DELETE:/administration/users/:id/sessions.json", type: :request do
    include_context 'request user authentication'

    before do
        @current_user.sessions.create!({})

        # get an ID that does not exist in the user sessions
        @invalid_id = @current_user.sessions.last.id + 1

        delete "/administration/users/#{@current_user.id}/sessions/#{@invalid_id}.json"
    end

    it "is expected to respond with not found standard json response" do
        expect_json_response_not_found
    end

    it "is expected to return with error when an invalid session id is sent" do
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)

        expect(response_error).to have_key("details")
        expect(response_error["details"]).to be_an(Array)
    end
end

RSpec.describe "DELETE:/administration/users/:id/sessions.json", type: :request do
    include_context 'request user authentication'

    before do
        # create a session for the current user
        @current_user.sessions.create!({})
        @last_id_session = @current_user.sessions.last.id

        # create a new user to test that a user cannot destroy sessions that are not his
        @new_user = User.new(attributes_for(:user))
        @new_user.confirm
        @new_user.save!
        
        sign_in @new_user

        delete "/administration/users/#{@current_user.id}/sessions/#{@last_id_session}.json"
    end

    it "is expected to respond with unauthorized standard json response" do
        expect_json_response_unauthorized
    end

    it "is expected to return with error when an invalid session id is sent" do
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)
    end
end