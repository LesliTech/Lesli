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
    describe "POST:/administration/account/files.json", type: :request do
        include_context "request user authentication"
        
        it "is expected pass share example response with successful" do
            @current_user.account.files.destroy_all

            post("/administration/account/files.json",params: {
                account_file: {
                    name: "company_logo",
                    file_type: "app_logo",
                    attachment: fixture_file_upload("lesli-icon.png", "image/png"),
                }
            })
            #share example
            expect_response_with_successful
            
            puts "respuesta #{response_body}"
        end

        it "is expected to respond a hash not empty with diferent key value" do
            @current_user.account.files.destroy_all
        
            file_subject = @current_user.account.files.new({
                name: "lesli-icon",
                attachment: fixture_file_upload("lesli-icon.png", "image/png"),
                file_type: "app_logo"
            })

            post("/administration/account/files.json",params: {
                account_file: {
                    name: "company_logo",
                    file_type: "app_logo",
                    attachment: fixture_file_upload("lesli-icon.png", "image/png"),
                }
            })
            #share example
            expect_response_with_successful
            
            #keyvalues check 
            puts "respuesta #{response_body}"
            expect(response_body).to be_a(Hash)
            expect(response_body).to have_key("id")
            expect(response_body).to have_key("name")
            expect(response_body["name"]).to be_a(String)
            expect(response_body).to have_key("attachment")
            expect(response_body["attachment"]).to be_a(Hash)
            expect(response_body["attachment"]).to have_key("url")
            expect(response_body["attachment"]["url"]).to be_a(String)
            expect(response_body).to have_key("attachment_s3")
            expect(response_body["attachment_s3"]).to be_a(Hash)
            expect(response_body["attachment_s3"]).to have_key("url")
            expect(response_body).to have_key("attachment_public")
            expect(response_body["attachment_public"]).to be_a(Hash)
            expect(response_body["attachment_public"]).to have_key("url")
            expect(response_body).to have_key("public")
            expect(response_body["public"]).to be_in([true, false])
            expect(response_body).to have_key("deleted_at")
            expect(response_body).to have_key("size_mb")
            expect(response_body).to have_key("external_url")
            expect(response_body).to have_key("external_url_expiration_date")
            expect(response_body).to have_key("created_at")
            expect(response_body["created_at"]).to be_a(String)
            expect(response_body).to have_key("updated_at")
            expect(response_body["updated_at"]).to be_a(String)
            expect(response_body).to have_key("users_id")
            expect(response_body["users_id"]).to be_a(Numeric)
            expect(response_body).to have_key("accounts_id")
            expect(response_body["accounts_id"]).to be_a(Numeric)
        end
        
        it "is expected to fail when a name param is empty" do
            @current_user.account.files.destroy_all
        
            post("/administration/account/files.json",params: {
                account_file: {
                    name: "",
                    file_type: "",
                    attachment: "",
                }
            })
            #share example
            expect_response_with_successful
            
            puts "respuesta #{response_body}"
        end
    end
end
