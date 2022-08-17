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

RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/account/files.json", type: :request do
        include_context "request user authentication"
        
        it "is expected pass share example response with successful" do
            @current_user.account.files.destroy_all
        
            file_subject = @current_user.account.files.new({
                name: "lesli-icon",
                attachment: fixture_file_upload("lesli-icon.png", "image/png"),
                file_type: "app_logo"
            })

            file_subject.user_creator = @user
            file_subject.save
            file_subject.update({})

            get("/administration/account/files.json")
            #share example
            expect_response_with_successful

        end

        it "is expected to return files account with all keys" do
            @current_user.account.files.destroy_all
        
            file_subject = @current_user.account.files.new({
                name: "lesli-icon",
                attachment: fixture_file_upload("lesli-icon.png", "image/png"),
                file_type: "app_logo"
            })

            get("/administration/account/files.json")

            #share example
            expect_response_with_successful

            #validate keywords 
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Array)
            expect(response_body.first).to be_an(Hash)
            expect(response_body.length).to be >= 1
            expect(response_body.first).to have_key("id")
            expect(response_body.first).to have_key("name")
            expect(response_body.first).to have_key("attachment")
            expect(response_body.first["attachment"]).to have_key("url")
            expect(response_body.first).to have_key("attachment_s3")
            expect(response_body.first["attachment_s3"]).to have_key("url")
            expect(response_body.first).to have_key("attachment_public")
            expect(response_body.first["attachment_public"]).to be_an(Hash)
            expect(response_body.first["attachment_public"]).to have_key("url")
            expect(response_body.first).to have_key("public")
            expect(response_body.first).to have_key("file_type")
            expect(response_body.first).to have_key("deleted_at")
            expect(response_body.first).to have_key("size_mb")
            expect(response_body.first).to have_key("external_url")
            expect(response_body.first).to have_key("external_url_expiration_date")
            expect(response_body.first).to have_key("created_at")
            expect(response_body.first).to have_key("updated_at")
            expect(response_body.first).to have_key("users_id")
            expect(response_body.first).to have_key("accounts_id")
        end
    end
end
