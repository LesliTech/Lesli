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

RSpec.describe "DELETE:/administration/account/files/:id", type: :request do 
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
        
        delete "/administration/account/files/#{file_subject.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to have deleted the file" do
        expect(@response_body["data"]).to be_nil
        # the file should no longer be in the database
        expect(@user.account.files.find_by(id: file_subject.id).to_json).to be_a(String)
        expect(@user.account.files.find_by(id: file_subject.id).to_json).to eql("null")

    end

end


RSpec.describe "DELETE:/administration/account/files/:id", type: :request do 
    include_context "user authentication"

    before(:all) do 
        # Set file id that does not exist
        @invalid_file_id = @user.account.files.all.order(id: :asc).last["id"] + 1

        delete "/administration/account/files/#{@invalid_file_id}.json"
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