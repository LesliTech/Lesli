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

RSpec.describe "POST:/administration/account/files", type: :request do
    include ActionDispatch::TestProcess::FixtureFile
    include_context "user authentication"

    before(:all) do 
        @name = "company_logo"
        @file_type = "app_logo"
        @attachment = fixture_file_upload("lesli-icon.png", "image/png")

        post("/administration/account/files.json", params: {
            account_file: {
                name: @name,
                file_type: @file_type,
                attachment: @attachment,
            }
        })
    end

    include_examples "successful standard json response"

    it "is expected to upload a file and respond with all keys" do 
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@name)

        expect(@response_body_data).to have_key("attachment")
        expect(@response_body_data["attachment"]).to be_a(Hash)
        expect(@response_body_data["attachment"]).to have_key("url")
        expect(@response_body_data["attachment"]["url"]).to be_a(String)

        expect(@response_body_data).to have_key("attachment_s3")
        expect(@response_body_data["attachment_s3"]).to be_a(Hash)
        expect(@response_body_data["attachment_s3"]).to have_key("url")
        expect(@response_body_data["attachment_s3"]["url"]).to be_nil

        expect(@response_body_data).to have_key("attachment_public")
        expect(@response_body_data["attachment_public"]).to be_a(Hash)
        expect(@response_body_data["attachment_public"]).to have_key("url")
        expect(@response_body_data["attachment_public"]["url"]).to be_nil

        expect(@response_body_data).to have_key("public")
        expect(@response_body_data["public"]).to be_in([true, false])

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("size_mb")
        expect(@response_body_data["size_mb"]).to be_nil

        expect(@response_body_data).to have_key("external_url")
        expect(@response_body_data["external_url"]).to be_nil

        expect(@response_body_data).to have_key("external_url_expiration_date")
        expect(@response_body_data["external_url_expiration_date"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("users_id")
        expect(@response_body_data["users_id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("accounts_id")
        expect(@response_body_data["accounts_id"]).to be_a(Numeric)

    end

end

RSpec.describe "POST:/administration/account/files", type: :request do 
    include ActionDispatch::TestProcess::FixtureFile
    include_context "user authentication"

    before(:all) do 

        post("/administration/account/files.json", params: {
            account_file: {
                # without params, should return error response
                name: "",
                file_type: "",
                attachment: ""
            }
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with error when params are empty strings" do 
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end 

RSpec.describe "POST:/administration/account/files", type: :request do 
    include ActionDispatch::TestProcess::FixtureFile
    include_context "user authentication"

    before(:all) do 

        post("/administration/account/files.json", params: {
            account_file: {
                # without params, should return error response
                name: nil,
                file_type: nil,
                attachment: nil
            }
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with error when params are nil" do 
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end 
