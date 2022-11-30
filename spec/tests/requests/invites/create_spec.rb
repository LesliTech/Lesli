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


RSpec.describe 'Post:/invite.json', type: :request do
    
    include_context "request user authentication" 
    
    it "returns a successfull response" do
        invite = {
            :full_name => Faker::Name.name,
            :email => Faker::Internet.email,
            :telephone => Faker::PhoneNumber.cell_phone,
            :note => Faker::Lorem.sentence,
        }
        
        post "/invite.json", :params =>{:invite => invite} 
        
        expect_response_with_successful
        
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key("id")
        expect(response_body["id"]).to be_a(Numeric)
        
        expect(response_body).to have_key("email")
        expect(response_body["email"]).to be_a(String)
        
        expect(response_body).to have_key("full_name")
        expect(response_body["full_name"]).to be_a(String)
        
        expect(response_body).to have_key("telephone")
        expect(response_body["telephone"]).to be_a(String)
        
        expect(response_body).to have_key("note")
        expect(response_body["note"]).to be_a(String)
        
        expect(response_body).to have_key("created_at")
        expect(response_body["created_at"]).to be_a(String)
        
        expect(response_body).to have_key("updated_at")
        expect(response_body["updated_at"]).to be_a(String)
        
        expect(response_body).to have_key("accounts_id")
        
    end    
    
    it 'is expects to have an error' do 
        post "/invite.json", :params => { 
            :invite => {
                :full_name => nil,
                :email => nil,
                :telephone => nil,
                :note => nil,
                :accounts_id => nil
            }
        } 
        expect_response_with_error
    end
    
    it 'is expects to have an error' do 
        post "/invite.json", :params => { 
            :invite => {
                :full_name => "",
                :email => "",
                :telephone => "",
                :note => "",
                :accounts_id => ""
            }
        } 
        expect_response_with_error
    end
    
    it "returns a content type to be text/html" do
        
        post "/invite.json", :params => {
            invite: {
                full_name: Faker::Name.name,
                email: Faker::Internet.email,
                telephone: Faker::PhoneNumber.cell_phone,
                note:Faker::Lorem.sentence
            }
        }
        
        expect(response.content_type).to eq "application/json; charset=utf-8"
    end
    
    
    
end




