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

require "rails_helper"
require "spec_helper"
require "byebug"

file_subject = nil

RSpec.describe "GET:/administration/account/files/:id", type: :request do
    include ActionDispatch::TestProcess::FixtureFile
    include_context "user authentication"

    before(:all) do 
        @name = "company_logo"
        @file_type = "app_logo"
        @attachment = fixture_file_upload("lesli-icon.png", "image/png")   

        
        file_subject = @user.account.files.new({
            name: @name,
            file_type: @file_type,
            attachment: @attachment
        })

        file_subject.user_creator = @user
        file_subject.save
        file_subject.update({})
        
        get "/administration/account/files/#{file_subject.id}.json"
    end

    it "is expected to return a file image" do 
        expect(response).to have_http_status(:success)
        expect(response.content_type).to be_a(String)
        expect(response.content_type).to eq("image/png")
        expect(response.body).to be_a(String)
    end


end

RSpec.describe "GET:/administration/account/files/:id", type: :request do 
    include_context "user authentication"

    before(:all) do 
        # Set file id that does not exist
        @invalid_file_id = @user.account.files.all.order(id: :asc).last["id"] + 1

        get "/administration/account/files/#{@invalid_file_id}.json"
    end 

    include_examples "not found standard json response"

    it "is expected to respond with not found" do 
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end
