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
    describe "GET:/administration.json", type: :request do
        include_context "request user authentication"
        
        it "is expected pass share example response with successful" do
            get("/administration.json")

            #share example
            expect_response_with_successful
        end

        it "is expected to respond a hash not empty with diferent key value" do
            get("/administration.json")

            #share examples
            expect_response_with_successful

            #validate response hash not null and keywords
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Hash)
            expect(response_body).to have_key("id")
            expect(response_body).to have_key("status")
            expect(response_body).to have_key("company_name")
            expect(response_body).to have_key("company_name_legal")
            expect(response_body).to have_key("company_tag_line")
            expect(response_body).to have_key("country")
            expect(response_body).to have_key("address")
            expect(response_body).to have_key("region")
            expect(response_body).to have_key("website")
            expect(response_body).to have_key("phone_number_1")
            expect(response_body).to have_key("phone_number_2")
            expect(response_body).to have_key("phone_number_3")
            expect(response_body).to have_key("phone_number_4")
            expect(response_body).to have_key("public_email")
            expect(response_body).to have_key("github")
            expect(response_body).to have_key("twitter")
            expect(response_body).to have_key("youtube")
            expect(response_body).to have_key("linkedin")
            expect(response_body).to have_key("facebook")
            expect(response_body).to have_key("created_at")
            expect(response_body).to have_key("updated_at")
            expect(response_body).to have_key("users_id")
            expect(response_body).to have_key("city")
            expect(response_body).to have_key("postal_code")
        end 

        it "is expected to have current user account values" do
            get("/administration.json")

            #share examples
            expect_response_with_successful
            
            #validate keyvalues values 
            expect(response_body["id"]).to eq(@current_user.account.id)
            expect(response_body["status"]).to eq(@current_user.account.status)
            expect(response_body["company_name"]).to eq(@current_user.account.company_name)
            expect(response_body["company_name_legal"]).to eq(@current_user.account.company_name_legal)
            expect(response_body["company_tag_line"]).to eq(@current_user.account.company_tag_line)
            expect(response_body["country"]).to eq(@current_user.account.country)
            expect(response_body["address"]).to eq(@current_user.account.address)
            expect(response_body["region"]).to eq(@current_user.account.region)
            expect(response_body["website"]).to eq(@current_user.account.website)
            expect(response_body["phone_number_1"]).to eq(@current_user.account.phone_number_1)
            expect(response_body["phone_number_2"]).to eq(@current_user.account.phone_number_2)
            expect(response_body["phone_number_3"]).to eq(@current_user.account.phone_number_3)
            expect(response_body["phone_number_4"]).to eq(@current_user.account.phone_number_4)
            expect(response_body["public_email"]).to eq(@current_user.account.public_email)
            expect(response_body["github"]).to eq(@current_user.account.github)
            expect(response_body["twitter"]).to eq(@current_user.account.twitter)
            expect(response_body["youtube"]).to eq(@current_user.account.youtube)
            expect(response_body["linkedin"]).to eq(@current_user.account.linkedin)
            expect(response_body["facebook"]).to eq(@current_user.account.facebook)
            expect(response_body["users_id"]).to eq(@current_user.account.users_id)
            expect(response_body["city"]).to eq(@current_user.account.city)
            expect(response_body["postal_code"]).to eq(@current_user.account.postal_code)
        end 
    end
end
