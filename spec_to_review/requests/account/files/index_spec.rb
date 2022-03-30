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

[
    {
        :name => "company_logo",
        :file_type => "app_logo"
    },
    {
        :name => "company_logo",
        :file_type => "app_logo",
        :attachment_s3 => nil,
        :attachment_public => nil,
        :public => nil,
        :size_mb => nil,
        :external_url => nil,
        :external_url_expiration_date => nil,
    }
].each do |file|
    
    RSpec.describe "GET:/administration/account/files", type: :request do
        include ActionDispatch::TestProcess::FixtureFile
        include_context "user authentication"

        before(:all) do 
            file_subject = nil

            @user.account.files.destroy_all
        
            file_subject = @user.account.files.new({
                name: file[:name],
                attachment: fixture_file_upload("lesli-icon.png", "image/png"),
                file_type: file[:file_type]
            })

            file_subject.user_creator = @user
            file_subject.save
            file_subject.update({})
        
            get "/administration/account/files.json"
        end

        include_examples "successful standard json response"

        it "is expected to return files account with all keys" do 
            expect(@response_body_data).to be_an(Array)
            expect(@response_body_data.length).to eq(1)

            expect(@response_body_data.at(0)).to be_a(Hash)

            expect(@response_body_data.at(0)).to have_key("id")
            expect(@response_body_data.at(0)["id"]).to be_a(Numeric)

            expect(@response_body_data.at(0)).to have_key("name")
            expect(@response_body_data.at(0)["name"]).to be_a(String)

            expect(@response_body_data.at(0)).to have_key("attachment")
            expect(@response_body_data.at(0)["attachment"]).to be_a(Hash)
            expect(@response_body_data.at(0)["attachment"]).to have_key("url")
            expect(@response_body_data.at(0)["attachment"]["url"]).to be_a(String)
                    
            expect(@response_body_data.at(0)).to have_key("attachment_s3")
            expect(@response_body_data.at(0)["attachment_s3"]).to be_a(Hash)
            expect(@response_body_data.at(0)["attachment_s3"]).to have_key("url")
            expect(@response_body_data.at(0)["attachment_s3"]["url"]).to be_nil

            expect(@response_body_data.at(0)).to have_key("attachment_public")
            expect(@response_body_data.at(0)["attachment_public"]).to have_key("url")
            expect(@response_body_data.at(0)["attachment_public"]["url"]).to be_nil
                    
            expect(@response_body_data.at(0)).to have_key("public")
            expect(@response_body_data.at(0)["public"]).to be_in([true, false])

            expect(@response_body_data.at(0)).to have_key("file_type")
            expect(@response_body_data.at(0)["file_type"]).to be_a(String)

            expect(@response_body_data.at(0)).to have_key("deleted_at")
            expect(@response_body_data.at(0)["deleted_at"]).to be_nil

            expect(@response_body_data.at(0)).to have_key("size_mb")
            expect(@response_body_data.at(0)["size_md"]).to be_nil

            expect(@response_body_data.at(0)).to have_key("external_url_expiration_date")
            expect(@response_body_data.at(0)["external_url_expiration_date"]).to be_nil

            expect(@response_body_data.at(0)).to have_key("created_at")
            expect(@response_body_data.at(0)["created_at"]).to be_a(String)

            expect(@response_body_data.at(0)).to have_key("updated_at")
            expect(@response_body_data.at(0)["updated_at"]).to be_a(String)

            expect(@response_body_data.at(0)).to have_key("users_id")
            expect(@response_body_data.at(0)["users_id"]).to be_a(Numeric)

            expect(@response_body_data.at(0)).to have_key("accounts_id")
            expect(@response_body_data.at(0)["accounts_id"]).to be_a(Numeric) 

        end

    end
end
