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

RSpec.describe "GET:/administration/account/files", type: :request do

    include_context "user authentication"

    before(:all) do 
        get "/administration/account/files.json"
    end

    include_examples "successful standard json response"

    it "is expected to return files account with all keys" do 
        expect(@response_body_data).to be_an(Array)
    
        # some properties may be nil by default when a file is uploaded

        unless @response_body_data.empty?

            @response_body_data.each do |file|
                expect(file).to be_a(Hash)

                expect(file).to have_key("id")
                expect(file["id"]).to be_a(Numeric)

                expect(file).to have_key("name")
                expect(file["name"]).to be_a(String)

                expect(file).to have_key("attachment")
                expect(file["attachment"]).to be_a(Hash)
                expect(file["attachment"]).to have_key("url")
                expect(file["attachment"]["url"]).to be_a(String)
                
                expect(file).to have_key("attachment_s3")
                expect(file["attachment_s3"]).to be_a(Hash)
                expect(file["attachment_s3"]).to have_key("url")
                expect(file["attachment_s3"]["url"]).to be_nil

                expect(file).to have_key("attachment_public")
                expect(file["attachment_public"]).to have_key("url")
                expect(file["attachment_public"]["url"]).to be_nil
                
                expect(file).to have_key("public")
                expect(file["public"]).to be_in([true, false])

                expect(file).to have_key("file_type")
                expect(file["file_type"]).to be_a(String)

                expect(file).to have_key("deleted_at")
                expect(file["deleted_at"]).to be_nil

                expect(file).to have_key("size_mb")
                expect(file["size_md"]).to be_nil

                expect(file).to have_key("external_url_expiration_date")
                expect(file["external_url_expiration_date"]).to be_nil

                expect(file).to have_key("created_at")
                expect(file["created_at"]).to be_a(String)

                expect(file).to have_key("updated_at")
                expect(file["updated_at"]).to be_a(String)

                expect(file).to have_key("users_id")
                expect(file["users_id"]).to be_a(Numeric)

                expect(file).to have_key("accounts_id")
                expect(file["accounts_id"]).to be_a(Numeric) 
            end

        end

    end


end