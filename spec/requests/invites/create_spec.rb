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

# DO NOT FORGET TO DELETE ALL COMMENTED CODE WHEN THE RESPECTIVE ISSUES ARE RESOLVED

require 'rails_helper'
require 'spec_helper'
require 'byebug'

RSpec.describe 'POST:/invite', type: :request do
    include_context 'user authentication'

    before(:all) do
        @invite = {
            :email => Faker::Internet.email,
            :telephone => Faker::PhoneNumber.phone_number,
            :full_name => Faker::Name.name,
            :note => Faker::Lorem.paragraph
        }

        post("/invite.json", params: {
            invite: @invite
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create an invitation request' do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body["data"]["id"]).to be > 0
        
        expect(@response_body_data).to have_key("email")
        expect(@response_body_data["email"]).to be_a(String)
        expect(@response_body_data["email"]).to eql(@invite[:email])

        expect(@response_body_data).to have_key("full_name")
        expect(@response_body_data["full_name"]).to be_a(String)
        expect(@response_body_data["full_name"]).to eql(@invite[:full_name])

        expect(@response_body_data).to have_key("telephone")
        expect(@response_body_data["telephone"]).to be_a(String)
        expect(@response_body_data["telephone"]).to eql(@invite[:telephone])

        expect(@response_body_data).to have_key("note")
        expect(@response_body_data["note"]).to be_a(String)
        expect(@response_body_data["note"]).to eql(@invite[:note])

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("accounts_id")
        # expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        # expect(@response_body_data["accounts_id"]).to eql(@user.acount.id)
    end
end


RSpec.describe "POST:/invite", type: :request do
    include_context 'user authentication'

    let!(:nil_params) do
        @invite = {
            :email => nil,
            :telephone => nil,
            :full_name => nil,
            :note => nil
        }
    end

    let!(:empty_str_params) do
        @invite = {
            :email =>"",
            :telephone =>"",
            :full_name =>"",
            :note =>""
        }
    end

    describe "When params are nil" do
        before { post("/invite.json", params: { invite: nil_params }) }
        subject { JSON.parse(response.body) }
    
        it 'is expected to respond with a success status code (2xx)' do 
            expect(response).to have_http_status(:success) 
        end

        it "is expected to respond with a successful property and have a false value" do
            expect(subject).to have_key("successful")
            expect(subject["successful"]).to be_falsey
        end

        it "is expected the response to have an error property" do 
            expect(subject).to have_key("error")
        end
    end

    describe "When params are empty strings" do
        before { post("/invite.json", params: { invite: empty_str_params }) }
        subject { JSON.parse(response.body) }
    
        it 'is expected to respond with a success status code (2xx)' do 
            expect(response).to have_http_status(:success) 
        end

        it "is expected to respond with a successful property and have a false value" do
            expect(subject).to have_key("successful")
            expect(subject["successful"]).to be_falsey
        end

        it "is expected the response to have an error property" do 
            expect(subject).to have_key("error")
        end
    end
end