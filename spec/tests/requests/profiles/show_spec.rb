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
            
        #share examples
        it "is expected to respond with successful" do
            get("/administration/profile.json")
            puts "respuesta #{response_body}"
            expect_response_with_successful
        end

        #validate response hash not null and keywords
        it "is expected to respond a hash not empty with diferent key value" do
            get("/administration/profile.json")
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Hash)
            expect(response_body.length).to be >= 1
            expect(response_body.keys.sort).to eq ["active", "alias", "created_at", "detail_attributes", "editable_security", "email", "full_name", "id", "mfa_enabled", "mfa_method", "roles", "updated_at"].sort
        end

        #validate keywords type 
        it "validate type data of hash" do 
            get("/administration/profile.json")
            expect(response_body["id"]).to be_a(Numeric)
            expect(response_body["email"]).to be_a(String)
            expect(response_body["alias"]).to be_a(String)
            expect(response_body["active"]).to be_in([true, false])
            expect(response_body["created_at"]).to be_a(String)
            expect(response_body["updated_at"]).to be_a(String)
            expect(response_body["mfa_enabled"]).to be_in([true, false])
            expect(response_body["editable_security"]).to be_in([true, false])
            expect(response_body["mfa_method"]).to be_nil
        end

        #validate detail_atributes hash and keyword
        it "validate detail_attributes hash and attributes" do 
            get("/administration/profile.json")
            expect(response_body["detail_attributes"]).not_to be_nil 
            expect(response_body["detail_attributes"]).to be_an(Hash)
            expect(response_body["detail_attributes"].keys.sort).to eq ["address", "first_name", "last_name", "salutation", "telephone", "title", "work_address", "work_city", "work_region"].sort
        end

        #validate roles hash and keyword
        it "validate roles hash and attributes" do 
            get("/administration/profile.json")
            expect_response_with_successful
            expect(response_body["roles"].first).not_to be_nil 
            expect(response_body["roles"].first).to be_an(Hash)
            expect(response_body["roles"].first.keys.sort).to eq ["id", "name"].sort
        end
    end
end
