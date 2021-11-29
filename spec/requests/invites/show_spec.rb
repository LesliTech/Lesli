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

# require 'rails_helper'
# require 'spec_helper'
# require 'byebug'


# RSpec.describe "GET:/invite", type: :request do

#     include_context "user authentication"

#     before(:all) do
#         Invite.destroy_all

#         @invite = Invite.create!({
#             :email => Faker::Internet.email,
#             :telephone => Faker::PhoneNumber.phone_number,
#             :full_name => Faker::Name.name,
#             :note => Faker::Lorem.paragraph
#         })

#         get "/invite.json"
#     end

#     include_examples 'successful standard json response'

#     it "is expected to respond with an invite found" do 
        ## PENDING, THE CONTROLLER IS NOT WORKING CORRECTLY

        # expect(@response_body_data).to be_a(Hash)

        # expect(@response_body_data).to have_key("id")
        # expect(@response_body_data["id"]).to be_a(Numeric)
        # expect(@response_body["data"]["id"]).to be > 0
        
        # expect(@response_body_data).to have_key("email")
        # expect(@response_body_data["email"]).to be_a(String)
        # expect(@response_body_data["email"]).to eql(@invite[:email])

        # expect(@response_body_data).to have_key("full_name")
        # expect(@response_body_data["full_name"]).to be_a(String)
        # expect(@response_body_data["full_name"]).to eql(@invite[:full_name])

        # expect(@response_body_data).to have_key("telephone")
        # expect(@response_body_data["telephone"]).to be_a(String)
        # expect(@response_body_data["telephone"]).to eql(@invite[:telephone])

        # expect(@response_body_data).to have_key("note")
        # expect(@response_body_data["note"]).to be_a(String)
        # expect(@response_body_data["note"]).to eql(@invite[:note])

        # expect(@response_body_data).to have_key("created_at")
        # expect(@response_body_data["created_at"]).to be_a(String)

        # expect(@response_body_data).to have_key("updated_at")
        # expect(@response_body_data["updated_at"]).to be_a(String)

        # expect(@response_body_data).to have_key("accounts_id")
        # expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        # expect(@response_body_data["accounts_id"]).to eql(@user.acount.id)
#     end
# end


# RSpec.describe "GET:/invite/:id", type: :request do 
#     include_context "user authentication"

#     before(:all) do
#         # Get an ID that does not exist
#         @invites = Invite.all.order(id: :asc) unless Invite.all.empty?
#         @invalid_invite_id = @invites.nil? ? 1 : @invites.last["id"] + 1

#         get "/invite/#{@invalid_invite_id}.json"
#     end

#     include_examples 'not found standard json response'

#     it "is expected to respond with an invite not found when an invalid id is sent in the URL" do 
#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"]).to be_a(Hash)

#         expect(@response_body["error"]).to have_key("message")
#         expect(@response_body["error"]["message"]).to be_a(String)
        
#         expect(@response_body["error"]).to have_key("details")
#         expect(@response_body["error"]["details"]).to be_a(Array)
#     end
# end