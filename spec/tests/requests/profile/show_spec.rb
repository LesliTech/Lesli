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
    describe "GET:/administration/profile.json", type: :request do
        include_context "request user authentication"
            
        it "is expected to respond with successful" do
            get("/administration/profile.json")

            #share examples
            expect_response_with_successful

        end

        it "is expected to respond a hash not empty with diferent key value" do
            get("/administration/profile.json")

            #share examples
            expect_response_with_successful
            LC::Debug.deprecation(response_body)

            #validate response hash not null and keywords
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Hash)
            expect(response_body.length).to be >= 1
            expect(response_body).to have_key("id")
            expect(response_body).to have_key("active")
            expect(response_body).to have_key("alias")
            expect(response_body).to have_key("created_at")
            expect(response_body).to have_key("detail_attributes")
            expect(response_body).to have_key("editable_security")
            expect(response_body).to have_key("email")
            expect(response_body).to have_key("full_name")
            expect(response_body).to have_key("mfa_enabled")
            expect(response_body).to have_key("mfa_method")
            expect(response_body).to have_key("roles")
            expect(response_body).to have_key("updated_at")

        end
 
        it "is expected to validate type data of hash" do 
            get("/administration/profile.json")

            #share examples
            expect_response_with_successful

            #validate keywords type and values
            expect(response_body["id"]).to be_a(Numeric)
            expect(response_body["id"]).to eq(1)
            expect(response_body["email"]).to be_a(String)
            expect(response_body["email"]).to eq("hello@lesli.tech")
            expect(response_body["full_name"]).to be_a(String)
            expect(response_body["full_name"]).to eq("Lesli Admin ")
            expect(response_body["alias"]).to be_a(String)
            expect(response_body["alias"]).to eq("Le ")
            expect(response_body["active"]).to be_in([true, false])
            expect(response_body["active"]).to eq(true)
            expect(response_body["created_at"]).to be_a(String)
            expect(response_body["updated_at"]).to be_a(String)
            expect(response_body["mfa_enabled"]).to be_in([true, false])
            expect(response_body["mfa_enabled"]).to eq(false)
            expect(response_body["editable_security"]).to be_in([true, false])
            expect(response_body["editable_security"]).to eq(true)
            expect(response_body["mfa_method"]).to be_nil

        end

        it "is expected to validate detail_attributes hash and attributes" do 
            get("/administration/profile.json")

            #share examples
            expect_response_with_successful

            #validate detail_atributes as a hash, keyword and keyword values
            expect(response_body["detail_attributes"]).not_to be_nil 
            expect(response_body["detail_attributes"]).to be_an(Hash)
            expect(response_body["detail_attributes"]).to have_key("address")
            expect(response_body["detail_attributes"]["address"]).to be_nil
            expect(response_body["detail_attributes"]).to have_key("first_name")
            expect(response_body["detail_attributes"]["first_name"]).to eq("Lesli Admin")
            expect(response_body["detail_attributes"]).to have_key("last_name")
            expect(response_body["detail_attributes"]["last_name"]).to eq("")
            expect(response_body["detail_attributes"]).to have_key("salutation")
            expect(response_body["detail_attributes"]["salutation"]).to eq("mr")
            expect(response_body["detail_attributes"]).to have_key("telephone")
            expect(response_body["detail_attributes"]["telefone"]).to be_nil
            expect(response_body["detail_attributes"]).to have_key("title")
            expect(response_body["detail_attributes"]["title"]).to be_nil
            expect(response_body["detail_attributes"]).to have_key("work_address")
            expect(response_body["detail_attributes"]["work_address"]).to be_nil
            expect(response_body["detail_attributes"]).to have_key("work_city")
            expect(response_body["detail_attributes"]["work_city"]).to be_nil
            expect(response_body["detail_attributes"]).to have_key("work_region")
            expect(response_body["detail_attributes"]["work_region"]).to be_nil

        end

        it "is expected to validate roles hash and attributes" do 
            get("/administration/profile.json")
            
            #share examples
            expect_response_with_successful

            #validate roles hash, keyword and keyword values
            expect(response_body["roles"].first).not_to be_nil 
            expect(response_body["roles"].first).to be_an(Hash)
            expect(response_body["roles"].first).to have_key("id")
            expect(response_body["roles"].first["id"]).to eq(1)
            expect(response_body["roles"].first).to have_key("name")
            expect(response_body["roles"].first["name"]).to eq("owner")

        end
    end
end